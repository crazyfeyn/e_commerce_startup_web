import 'package:e_commerce_startup_web/core/utils/app_assets.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/data/models/language_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LangService {
  //assets path
  static const path = 'assets/translations';

  // Default locale
  static final locale = Locale("en", "US");

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale("en", "US");

  // Supported locales
  // Needs to be same orders with languages
  static final supportedLocales = [
    const Locale("ko", "KR"),
    // const Locale("en", "US"),
  ];

  // Gets locale from language, and updates the locale
  static void changeLocale(BuildContext context, String langCode) {
    final result = supportedLocales.firstWhere((e) => e.languageCode == langCode, orElse: () => supportedLocales.first);
    context.setLocale(result);
    DBService.setLanguage(result.toStringWithSeparator(separator: "-"));
  }

  static String get currentLocale {
    final localeLang = DBService.getLanguage();
    if (localeLang == null) {
      return fallbackLocale.toStringWithSeparator(separator: "-");
    }
    return localeLang;
  }

  static List<LanguageModel> getLanguages() {
    return supportedLocales.map(
          (e) => LanguageModel(
            name: langName(e.languageCode),
            icon: langIcon(e.languageCode),
            languageCode: e.languageCode,
            countryCode: e.countryCode,
          ),
        ).toList();
  }

  static String langName(String languageCode) {
    switch (languageCode) {
      case 'ko': return LocaleKeys.lang_ko.tr();
      case 'en': return LocaleKeys.lang_en.tr();
      default: throw "Exception: Not found";
    }
  }

  static String langIcon(String languageCode) {
    switch (languageCode) {
      case 'ko': return AppAssets.icons.flagKo;
      case 'en': return AppAssets.icons.flagUs;
      default: throw "Exception: Not found";
    }
  }
}
