import 'package:flutter/material.dart';

enum AppLocale {
  en,
  ar,
}

extension AppLocaleX on AppLocale {
  Locale get material => Locale(name);

  static AppLocale fromCode(String code) {
    return code == AppLocale.ar.name ? AppLocale.ar : AppLocale.en;
  }
}
