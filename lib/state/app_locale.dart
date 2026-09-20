import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/translations.dart';


enum AppLanguage { english, marathi, hindi }

extension AppLanguageLabel on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.marathi:
        return 'mr';
      case AppLanguage.hindi:
        return 'hi';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.marathi:
        return 'मराठी';
      case AppLanguage.hindi:
        return 'हिंदी';
    }
  }

  static AppLanguage fromCode(String? code) {
    switch (code) {
      case 'mr':
        return AppLanguage.marathi;
      case 'hi':
        return AppLanguage.hindi;
      default:
        return AppLanguage.english;
    }
  }
}

class AppLocale extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  static const _prefsKey = 'app_language_code';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _language = AppLanguageLabel.fromCode(prefs.getString(_prefsKey));
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language.code);
  }

  /// Translate a key for the current language, falling back to English and
  /// then to the key itself so a missing translation never crashes the UI.
  String t(String key) {
    final table = translations[_language.code] ?? translations['en']!;
    return table[key] ?? translations['en']![key] ?? key;
  }

  static AppLocale of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_AppLocaleScope>();
    assert(scope != null, 'AppLocaleProvider missing above this widget');
    return scope!.notifier!;
  }
}

class AppLocaleProvider extends StatefulWidget {
  final Widget child;
  const AppLocaleProvider({super.key, required this.child});

  @override
  State<AppLocaleProvider> createState() => _AppLocaleProviderState();
}

class _AppLocaleProviderState extends State<AppLocaleProvider> {
  final AppLocale _locale = AppLocale();

  @override
  void initState() {
    super.initState();
    _locale.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _locale,
      builder: (context, _) {
        return _AppLocaleScope(
          notifier: _locale,
          child: widget.child,
        );
      },
    );
  }
}

class _AppLocaleScope extends InheritedNotifier<AppLocale> {
  const _AppLocaleScope({required super.notifier, required super.child});
}
