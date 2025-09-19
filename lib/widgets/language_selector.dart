import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/localization_service.dart';

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final availableLanguages = LocalizationService.getAvailableLanguages();

    return AlertDialog(
      title: Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableLanguages.map((language) {
          return ListTile(
            title: Text(language['name']),
            onTap: () {
              languageProvider.changeLanguage(language['code']);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}