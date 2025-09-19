// lib/services/localization_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static Map<String, dynamic> _localizedValues = {};
  static List<Map<String, dynamic>> _availableLanguages = [];

    static Future<void> loadTranslations(String langCode) async {
    try {
      String jsonString = await rootBundle.loadString('assets/locales/$langCode.json');
      _localizedValues = json.decode(jsonString);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', langCode);
    } catch (e) {
      print('Error loading translations: $e');
    }
  }

  static Future<void> loadAvailableLanguages() async {
    try {
      // In a real app, you would fetch this from the API
      // For now, we'll use a static list
      _availableLanguages = [
        {'code': 'en', 'name': 'English'},
        {'code': 'hi', 'name': 'Hindi'},
      ];
    } catch (e) {
      print('Error loading available languages: $e');
    }
  }

  static String translate(String key) {
    return _localizedValues[key] ?? key;
  }

  static List<Map<String, dynamic>> getAvailableLanguages() {
    return _availableLanguages;
  }

  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'en';
  }
}