class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {'role': role, 'content': content};

  factory ChatMessage.user(String content) =>
      ChatMessage(role: 'user', content: content, timestamp: DateTime.now());

  factory ChatMessage.assistant(String content) => ChatMessage(
    role: 'assistant',
    content: content,
    timestamp: DateTime.now(),
  );
}
