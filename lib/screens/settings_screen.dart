import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Keep for some data types like Locale/ThemeMode if needed, or remove if unused. Keep for Colors.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarTheme = Theme.of(context).appBarTheme;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          l10n.settings,
          style: TextStyle(color: appBarTheme.foregroundColor),
        ),
        transitionBetweenRoutes: false,
        border: null,
        backgroundColor: appBarTheme.backgroundColor,
      ),
      backgroundColor: isDark
          ? Colors.black
          : CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CupertinoFormSection.insetGrouped(
                  header: Text(l10n.settings.toUpperCase()),
                  children: [
                    // Theme
                    CupertinoFormRow(
                      prefix: Text(l10n.theme),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          _getThemeText(themeProvider.themeMode, l10n),
                        ),
                        onPressed: () =>
                            _showThemePicker(context, themeProvider, l10n),
                      ),
                    ),

                    // Language
                    CupertinoFormRow(
                      prefix: Text(l10n.language),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          _getLanguageText(localeProvider.locale, l10n),
                        ),
                        onPressed: () =>
                            _showLanguagePicker(context, localeProvider, l10n),
                      ),
                    ),

                    // Currency
                    CupertinoFormRow(
                      prefix: Text(l10n.currency),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          _getCurrencyText(currencyProvider.currency, l10n),
                        ),
                        onPressed: () => _showCurrencyPicker(
                          context,
                          currencyProvider,
                          l10n,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    ThemeProvider provider,
    AppLocalizations l10n,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.theme),
        actions: ThemeMode.values.map((mode) {
          return CupertinoActionSheetAction(
            onPressed: () {
              provider.setThemeMode(mode);
              Navigator.pop(context);
            },
            child: Text(_getThemeText(mode, l10n)),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    LocaleProvider provider,
    AppLocalizations l10n,
  ) {
    final locales = [
      const Locale('en'),
      const Locale('es'),
      const Locale('tr'),
    ];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.language),
        actions: locales.map((locale) {
          return CupertinoActionSheetAction(
            onPressed: () {
              provider.setLocale(locale);
              Navigator.pop(context);
            },
            child: Text(_getLanguageText(locale, l10n)),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    CurrencyProvider provider,
    AppLocalizations l10n,
  ) {
    final currencies = CurrencyProvider.currencyOptions.keys.toList();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.currency),
        actions: currencies.map((symbol) {
          return CupertinoActionSheetAction(
            onPressed: () {
              provider.setCurrency(symbol);
              Navigator.pop(context);
            },
            child: Text(_getCurrencyText(symbol, l10n)),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text(l10n.cancel),
        ),
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
