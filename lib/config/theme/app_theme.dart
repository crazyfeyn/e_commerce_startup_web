import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const _inter = 'Inter';

  static var appTheme = ThemeData(
    fontFamily: _inter,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white50,
    colorScheme: const ColorScheme.light(primary: AppColors.primary500),
    textTheme: ThemeData.light().textTheme.apply(bodyColor: AppColors.black950),
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleSpacing: 16,
      centerTitle: false,
      backgroundColor: AppColors.white50,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppStyles.titleMDSemibold.copyWith(
        color: AppColors.black950,
      ),
      iconTheme: const IconThemeData(size: 20),
      actionsIconTheme: const IconThemeData(size: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.white50,
        backgroundColor: AppColors.primary500,
        minimumSize: Size(double.infinity, 56),
        maximumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppStyles.bodyMDSemibold,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.primary700,
        backgroundColor: AppColors.primary50,
        minimumSize: Size(double.infinity, 56),
        maximumSize: Size(double.infinity, 56),
        side: BorderSide(width: 1, color: AppColors.primary200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppStyles.bodyMDSemibold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.black50,
      iconColor: AppColors.black500,
      suffixIconColor: AppColors.black950,
      prefixIconColor: AppColors.black500,
      hintStyle: AppStyles.bodyMDRegular.copyWith(color: AppColors.black500),
      errorStyle: AppStyles.bodySMRegular.copyWith(color: AppColors.red500),
      border: InputBorder.none,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: AppColors.black100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: AppColors.black100),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: AppColors.red300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1, color: AppColors.red300),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary500,
      unselectedItemColor: AppColors.black400,
      selectedLabelStyle: AppStyles.labelMDMedium.copyWith(
        color: AppColors.black400,
      ),
      unselectedLabelStyle: AppStyles.labelMDSemibold.copyWith(
        color: AppColors.primary500,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.black950,
      labelStyle: AppStyles.labelLGSemibold,
      unselectedLabelColor: AppColors.black500,
      unselectedLabelStyle: AppStyles.labelLGMedium,
    ),
    dividerTheme: DividerThemeData(color: AppColors.black100),
  );

  AppTheme._();
}
