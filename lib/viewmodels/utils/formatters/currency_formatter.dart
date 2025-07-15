import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bom_hamburguer/injector.dart';
import 'package:bom_hamburguer/l10n/global_app_localizations.dart';

class CurrencyFormatter {
  static String formatCurrency(double value, {Locale? locale}) {
    Locale currentLocale;

    if (locale != null) {
      currentLocale = locale;
    } else {
      try {
        currentLocale = sl<GlobalAppLocalizations>().locale;
      } catch (e) {
        currentLocale = const Locale('pt');
      }
    }

    String currencySymbol;
    String localeString;

    switch (currentLocale.languageCode) {
      case 'pt':
        currencySymbol = 'R\$';
        localeString = 'pt_BR';
        break;
      case 'en':
        currencySymbol = '\$';
        localeString = 'en_US';
        break;
      default:
        currencySymbol = 'R\$';
        localeString = 'pt_BR';
    }

    final formatter = NumberFormat.currency(
      locale: localeString,
      symbol: currencySymbol,
      decimalDigits: 2,
    );

    return formatter.format(value);
  }

  static String formatCurrencyForCurrentLocale(double value) {
    return formatCurrency(value);
  }

  static String formatCurrencyCompact(double value) {
    Locale currentLocale;

    try {
      currentLocale = sl<GlobalAppLocalizations>().locale;
    } catch (e) {
      currentLocale = const Locale('pt');
    }

    String currencySymbol;
    String localeString;

    switch (currentLocale.languageCode) {
      case 'pt':
        currencySymbol = 'R\$';
        localeString = 'pt_BR';
        break;
      case 'en':
        currencySymbol = '\$';
        localeString = 'en_US';
        break;
      default:
        currencySymbol = 'R\$';
        localeString = 'pt_BR';
    }

    final formatter = NumberFormat.compactCurrency(
      locale: localeString,
      symbol: currencySymbol,
    );

    return formatter.format(value);
  }
}
