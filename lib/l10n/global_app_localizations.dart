import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class GlobalAppLocalizations {
  void setAppLocalizations(AppLocalizations? localizations);

  AppLocalizations get current;
  Locale get locale;
}

class GlobalAppLocalizationsImpl extends GlobalAppLocalizations {
  AppLocalizations? _appLocalizations;
  late Locale _locale;

  @override
  Locale get locale => _locale;

  @override
  void setAppLocalizations(AppLocalizations? localizations) {
    _appLocalizations = localizations;
    _locale = Locale(localizations?.localeName ?? 'en');
  }

  @override
  AppLocalizations get current {
    if (_appLocalizations == null) {
      throw Exception('AppLocalizations not initialized');
    } else {
      return _appLocalizations!;
    }
  }

  static String aOrAn(String word) {
    return _startsWithVowelSound(word) ? 'an' : 'a';
  }

  static bool _startsWithVowelSound(String word) {
    final firstLetter = word.toLowerCase()[0];
    return 'aeiou'.contains(firstLetter);
  }
}
