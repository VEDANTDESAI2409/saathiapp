import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/language_provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final currentLang = langProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(title: const Text('Language Settings / ભાષા / भाषा')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _langTile(
            context,
            langProvider,
            code: 'en',
            name: 'English',
            nativeName: 'English',
            isSelected: currentLang == 'en',
          ),
          _langTile(
            context,
            langProvider,
            code: 'gu',
            name: 'Gujarati',
            nativeName: 'ગુજરાતી',
            isSelected: currentLang == 'gu',
          ),
          _langTile(
            context,
            langProvider,
            code: 'hi',
            name: 'Hindi',
            nativeName: 'हिन्दी',
            isSelected: currentLang == 'hi',
          ),
        ],
      ),
    );
  }

  Widget _langTile(
    BuildContext context,
    LanguageProvider provider, {
    required String code,
    required String name,
    required String nativeName,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.trustTeal : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          nativeName,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.trustTeal)
            : null,
        onTap: () {
          provider.changeLanguage(code);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Language switched to $name')));
        },
      ),
    );
  }
}
