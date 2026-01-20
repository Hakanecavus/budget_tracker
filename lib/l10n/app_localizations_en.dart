// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Budget Tracker';

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get settings => 'Settings';

  @override
  String get reports => 'Reports';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get balance => 'Balance';

  @override
  String get selectDate => 'Select a date to view transactions';

  @override
  String get noTransactions => 'No transactions for this date';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get color => 'Color';

  @override
  String get type => 'Type';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String confirmDeleteCategory(Object name) {
    return 'Are you sure you want to delete the category \"$name\"?';
  }

  @override
  String get confirmDeleteTransaction => 'Are you sure you want to delete this transaction?';

  @override
  String get deleted => 'deleted';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get explanation => 'Explanation';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get turkish => 'Turkish';

  @override
  String get unknown => 'Unknown';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get pickColor => 'Pick a color';

  @override
  String get select => 'Select';

  @override
  String get monthFormat => 'Month';

  @override
  String get twoWeekFormat => '2 Week';

  @override
  String get weekFormat => 'Week';

  @override
  String get currency => 'Currency';

  @override
  String get usd => 'US Dollar (USD)';

  @override
  String get eur => 'Euro (EUR)';

  @override
  String get gbp => 'British Pound (GBP)';

  @override
  String get tl => 'Turkish Lira (TRY)';

  @override
  String get jpy => 'Japanese Yen (JPY)';

  @override
  String get inr => 'Indian Rupee (INR)';

  @override
  String get noCategories => 'No categories available';

  @override
  String get update => 'Update';

  @override
  String get breakdown => 'Details';

  @override
  String get total => 'Total';

  @override
  String get recurring => 'Recurring';

  @override
  String get isRecurring => 'Is Recurring?';

  @override
  String get endDate => 'End Date';

  @override
  String get tutorialAddTransactionTitle => 'Add Transaction';

  @override
  String get tutorialAddTransactionDesc => 'Tap here to add your first income or expense.';

  @override
  String get tutorialCategoriesTabTitle => 'Categories';

  @override
  String get tutorialCategoriesTabDesc => 'Manage your categories here to organize your finances.';

  @override
  String get tutorialAddCategoryTitle => 'Add Category';

  @override
  String get tutorialAddCategoryDesc => 'Create custom categories for better tracking.';

  @override
  String get tutorialReportsTabTitle => 'Reports';

  @override
  String get tutorialReportsTabDesc => 'View your financial summary and charts here.';

  @override
  String get tutorialReportsTitle => 'Reports Overview';

  @override
  String get tutorialReportsDesc => 'Analyze your spending habits with detailed charts.';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialFinish => 'Finish';
}
