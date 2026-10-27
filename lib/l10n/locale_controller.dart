import 'package:flutter/material.dart';
import 'package:reservations_app/l10n/app_localizations.dart';

/// Holds the locale the app should use.
///
/// A value of null means "automatic": the device language (the browser
/// language on web), falling back to English when it is not supported.
class LocaleController {
  LocaleController._();

  static const Locale fallbackLocale = Locale('en');

  static final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  /// Language code -> name, each written in its own language so users can
  /// always find theirs.
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'ca': 'Català',
  };

  /// Locale for a stored language code, or null (automatic) when there is no
  /// code or it is not supported.
  static Locale? fromCode(String? code) {
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == code) return supported;
    }
    return null;
  }

  static void setLanguage(String? code) {
    locale.value = fromCode(code);
  }

  /// Picks the first preferred locale whose language we support. Flutter's
  /// default would pick the first *supported* locale (Catalan, alphabetically)
  /// for unsupported languages, so fall back to English explicitly.
  static Locale resolve(
      List<Locale>? preferred, Iterable<Locale> supported) {
    for (final candidate in preferred ?? const <Locale>[]) {
      for (final locale in supported) {
        if (locale.languageCode == candidate.languageCode) return locale;
      }
    }
    return fallbackLocale;
  }
}
