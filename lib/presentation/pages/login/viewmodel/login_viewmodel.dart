import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/repositories/login_repository_impl.dart';
import 'package:flutter/material.dart';

class LoginViewmodel extends ChangeNotifier {
  final _repository = LoginRepositoryImpl();

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.initial;
  bool obscureText = true;
  bool isRegisterMode = false;

  void changeObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void toggleMode() {
    isRegisterMode = !isRegisterMode;
    formzStatus = FormzSubmissionStatus.initial;
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

  Future<bool> registerAdmin({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
    final token = DBService.ensure.getAccessToken();
    if (token.isEmpty) {
      GlobalSnackBar.showError("Admin register requires login (UNAUTHORIZED).");
      return false;
    }

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.registerAdmin(
      firstname: firstname,
      lastname: lastname,
      phoneNumber: phoneNumber,
      password: password,
    );

    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = res ? FormzSubmissionStatus.success : FormzSubmissionStatus.canceled;
      notifyListeners();
      return res;
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
      return false;
    }
  }
}