import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';

class LoginViewmodel extends ChangeNotifier {
  final _repository = LoginRepositoryImpl();

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.initial;
  bool obscureText = true;

  void changeObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }


  Future<bool> login(String phone, String password) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.login(phone, password);

    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));
      if(res) {
        formzStatus = FormzSubmissionStatus.success;
      } else {
        formzStatus = FormzSubmissionStatus.canceled;
      }
      notifyListeners();

      return res;
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
      return false;
    }
  }
}