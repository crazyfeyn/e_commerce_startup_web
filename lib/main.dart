import 'package:e_commerce_startup_web/config/router/app_router.dart';
import 'package:e_commerce_startup_web/config/theme/app_theme.dart';
import 'package:e_commerce_startup_web/core/services/lang_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String _maskToken(String? token) {
  if (token == null) return 'null';
  if (token.isEmpty) return '';
  final start = token.length >= 8 ? token.substring(0, 8) : token;
  final end = token.length >= 8 ? token.substring(token.length - 8) : '';
  return end.isEmpty ? '$start...' : '$start...$end';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await DBService.ensure.ensureInitialized();

  // Debug: verify what SharedPreferences currently stores.
  final accessToken = DBService.ensure.getAccessToken();
  final refreshToken = DBService.ensure.getRefreshToken();
  final clientId = DBService.ensure.getClientId();
  debugPrint('[DBService] init: accessToken(${accessToken.length})=${_maskToken(accessToken)}');
  debugPrint('[DBService] init: refreshToken(${refreshToken.length})=${_maskToken(refreshToken)}');
  debugPrint('[DBService] init: clientId=${clientId.isEmpty ? "(empty)" : clientId}');

  runApp(
    EasyLocalization(
      path: LangService.path,
      startLocale: LangService.fallbackLocale,
      fallbackLocale: LangService.fallbackLocale,
      supportedLocales: LangService.supportedLocales,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: MaterialApp.router(
        title: 'E-commerce',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: AppTheme.appTheme,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        scaffoldMessengerKey: GlobalSnackBar.scaffoldMessengerKey,
        builder: (context, child) {
          return MediaQuery(
            // ignore: deprecated_member_use
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
