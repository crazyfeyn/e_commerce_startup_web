import 'package:flutter/material.dart';

class AppColors {
  ///Black colors
  static const Color black50 = Color(0xFFF6F6F6);
  static const Color black100 = Color(0xFFE7E7E7);
  static const Color black200 = Color(0xFFD1D1D1);
  static const Color black300 = Color(0xFFB0B0B0);
  static const Color black400 = Color(0xFF888888);
  static const Color black500 = Color(0xFF6D6D6D);
  static const Color black600 = Color(0xFF5D5D5D);
  static const Color black700 = Color(0xFF4F4F4F);
  static const Color black800 = Color(0xFF454545);
  static const Color black900 = Color(0xFF3D3D3D);
  static const Color black950 = Color(0xFF111111);

  ///White colors
  static const Color white50 = Color(0xFFFFFFFF);
  static const Color white100 = Color(0xFFEFEFEF);
  static const Color white200 = Color(0xFFDCDCDC);
  static const Color white300 = Color(0xFFBDBDBD);
  static const Color white400 = Color(0xFF989898);
  static const Color white500 = Color(0xFF7C7C7C);
  static const Color white600 = Color(0xFF656565);
  static const Color white700 = Color(0xFF525252);
  static const Color white800 = Color(0xFF464646);
  static const Color white900 = Color(0xFF3D3D3D);
  static const Color white950 = Color(0xFF292929);

  /// Primary colors (Blue)
  static const Color primary50  = Color(0xFFEFF6FF);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary200 = Color(0xFFBFDBFE);
  static const Color primary300 = Color(0xFF93C5FD);
  static const Color primary400 = Color(0xFF60A5FA);
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary600 = Color(0xFF2563EB);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary800 = Color(0xFF1E40AF);
  static const Color primary900 = Color(0xFF1E3A8A);
  static const Color primary950 = Color(0xFF172554);


  ///Red colors
  static const Color error600 = Color(0xFFD92D20);
  static const Color red500 = Color(0xFFFF4C4C);
  static const Color red300 = Color(0xFFFDA29B);

  ///Purple colors
  static const Color purple100 = Color(0xFFF7EEFF);
  static const Color purple500 = Color(0xFF7A5AF8);
  static const Color purple600 = Color(0xFF9447D1);

  static const Color success = Color(0xFF29C184);
  static const Color warning400 = Color(0xFFFDB022);
  static const Color blue600 = Color(0xFF1570EF);
  static const Color textSecondary = Color(0xFF92929D);

  static const Color nF8F7F7 = Color(0xFFF8F7F7);

  static Color hexToColor(String? hexColor) {
    try {
      hexColor = (hexColor ?? "").toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch(_) {
      return primary500;
    }
  }

  const AppColors._();
}
