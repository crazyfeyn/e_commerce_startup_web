import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class GlobalSnackBar {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showError(String message, {String? title}) {
    showTopSnackBar(
      NavigationService.navigatorKey.currentState!.overlay!,
      CustomSnackBar.error(
        message: message,
        textStyle: AppStyles.labelLGRegular.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  static void showWarning(String title, String message) {
    showTopSnackBar(
      NavigationService.navigatorKey.currentState!.overlay!,
      CustomSnackBar.info(
        message: message,
        textStyle: AppStyles.labelLGRegular.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  static void showSuccess(String message, {String? title}) {
    showTopSnackBar(
      NavigationService.navigatorKey.currentState!.overlay!,
      CustomSnackBar.success(
        message: message,
        textStyle: AppStyles.labelLGRegular.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
