import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/models/chat_model.dart';
import 'package:e_commerce_startup_web/data/repositories/chat_repository_impl.dart';
import 'package:flutter/material.dart';

class ChatViewmodel extends ChangeNotifier {
  final _repository = ChatRepositoryImpl();
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // In-memory only — clears on refresh or app restart
  List<ChatMessage> messages = [];
  bool isLoading = false;

  ChatViewmodel() {
    // Show welcome message on init
    messages.add(
      ChatMessage.assistant(
        "Hello! I'm your Hilol Market admin assistant. "
        "I can help you manage products, categories, and orders. "
        "What would you like to do?",
      ),
    );
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isLoading) return;

    // Get token from local storage (adjust to your actual storage method)
    final token = DBService.ensure.getAccessToken();
    if (token.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(text);
    messages.add(userMessage);
    messageController.clear();
    isLoading = true;
    notifyListeners();
    _scrollToBottom();

    // Build history — everything except the last user message just added
    final history = messages
        .sublist(0, messages.length - 1)
        .where((m) => m.role != 'assistant' || messages.indexOf(m) > 0)
        .toList();

    final result = await _repository.sendMessage(text, history, token);

    result.fold(
      (error) {
        messages.add(
          ChatMessage.assistant(
            "Sorry, I encountered an error. Please try again.",
          ),
        );
      },
      (reply) {
        messages.add(ChatMessage.assistant(reply));
      },
    );

    isLoading = false;
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    _repository.dispose();
    super.dispose();
  }
}
