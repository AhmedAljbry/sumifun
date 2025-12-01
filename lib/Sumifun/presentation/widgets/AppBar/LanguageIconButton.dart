import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumfiun/Core/LocaleProvider.dart';


class LanguageIconButton extends StatelessWidget {
  const LanguageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LocaleProvider>().locale.languageCode;

    // علم بسيط (إيموجي) حسب اللغة الحالية
    String flagFor(String code) {
      switch (code) {
        case 'ar':
          return '🇸🇦'; // ممكن تغيّر لأي علم عربي تحبه
        case 'zh':
          return '🇨🇳';
        default:
          return '🇬🇧';
      }
    }

    return PopupMenuButton<String>(
      tooltip: 'Change Language',
      icon: Text(
        flagFor(current),
        style: const TextStyle(fontSize: 22),
      ),
      onSelected: (code) {
        context.read<LocaleProvider>().setLocale(Locale(code));
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'ar', child: Text('العربية 🇸🇦')),
        const PopupMenuItem(value: 'en', child: Text('English 🇬🇧')),
        const PopupMenuItem(value: 'zh', child: Text('中文 🇨🇳')),
      ],
    );
  }
}
