// lib/providers/language_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/localization_service.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => const [Locale('en'), Locale('hi')];

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final langCode = await LocalizationService.getCurrentLanguage();
    _currentLocale = Locale(langCode);
    await LocalizationService.loadTranslations(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await LocalizationService.loadTranslations(languageCode);
    notifyListeners();
  }

  String translate(String key) {
    return LocalizationService.translate(key);
  }
}