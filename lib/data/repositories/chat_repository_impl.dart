import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/network/cancel_token_manager.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_helper.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/chat_model.dart';

abstract class ChatRepository {
  Future<Either<String, String>> sendMessage(
    String message,
    List<ChatMessage> history,
    String token,
  );
  void dispose();
}

class ChatRepositoryImpl extends ChatRepository {
  late final CancelTokenManager cancelTokenManager;

  ChatRepositoryImpl() {
    cancelTokenManager = CancelTokenManager();
  }

  @override
  Future<Either<String, String>> sendMessage(
    String message,
    List<ChatMessage> history,
    String token,
  ) async {
    try {
      final api = NetworkService.apiChat;
      final cancelToken = cancelTokenManager.getToken(api);

      final body = {
        'message': message,
        'history': history.map((m) => m.toMap()).toList(),
        'token': token,
      };

      final response = await NetworkService.post(api, cancelToken, body);
      final reply = response['reply'] as String? ?? 'No response';
      return Right(reply);
    } on NetworkException catch (e) {
      if (e.type != NetworkExceptionType.cancelled) {
        GlobalSnackBar.showError(e.message);
      }
      return Left(e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  void dispose() => cancelTokenManager.cancelAll();
}
