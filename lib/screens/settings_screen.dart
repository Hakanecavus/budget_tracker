import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/currency_provider.dart';
import '../l10n/app_localizations.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(_getThemeText(themeProvider.themeMode, l10n)),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  themeProvider.setThemeMode(newMode);
                }
              },
              items: ThemeMode.values.map((mode) {
                return DropdownMenuItem<ThemeMode>(
                  value: mode,
                  child: Text(_getThemeText(mode, l10n)),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(_getLanguageText(localeProvider.locale, l10n)),
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('es'),
                  child: Text('Español'),
                ),
                DropdownMenuItem(
                  value: Locale('tr'),
                  child: Text('Türkçe'),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(l10n.currency),
            subtitle: Text(_getCurrencyText(currencyProvider.currency, l10n)),
            trailing: DropdownButton<String>(
              value: currencyProvider.currency,
              onChanged: (String? newCurrency) {
                if (newCurrency != null) {
                  currencyProvider.setCurrency(newCurrency);
                }
              },
              items: CurrencyProvider.currencyOptions.keys.map((symbol) {
                return DropdownMenuItem<String>(
                  value: symbol,
                  child: Text(_getCurrencyText(symbol, l10n)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.light;
      case ThemeMode.dark:
        return l10n.dark;
      case ThemeMode.system:
        return l10n.system;
    }
  }

  String _getLanguageText(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return l10n.english;
      case 'es':
        return l10n.spanish;
      case 'tr':
        return l10n.turkish;
      default:
        return l10n.english;
    }
  }

  String _getCurrencyText(String currencySymbol, AppLocalizations l10n) {
    final currencyMap = {
      '\$': l10n.usd,
      '€': l10n.eur,
      '£': l10n.gbp,
      '₺': l10n.tl,
      '¥': l10n.jpy,
      '₹': l10n.inr,
    };
    return currencyMap[currencySymbol] ?? l10n.usd;
  }
}