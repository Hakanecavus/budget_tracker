import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'settings_screen.dart';
import 'reports_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/tutorial_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);
  final GlobalKey _addTransactionKey = GlobalKey();
  final GlobalKey _categoriesTabKey = GlobalKey();
  final GlobalKey _addCategoryKey = GlobalKey();
  final GlobalKey _reportsTabKey = GlobalKey();
  final GlobalKey _reportsContentKey = GlobalKey();

  @override
  void dispose() {
    _indexNotifier.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _indexNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final tutorialProvider = Provider.of<TutorialProvider>(
      context,
      listen: false,
    );

    return ShowCaseWidget(
      onFinish: () {
        tutorialProvider.completeTutorial();
      },
      onComplete: (index, key) {
        if (index == 1) {
          // Finishing categoriesTabKey
          _onItemTapped(1);
        } else if (index == 3) {
          // Finishing reportsTabKey
          _onItemTapped(2);
        } else if (index == 0) {
          // Finishing addTransactionKey
          _onItemTapped(0);
        }
      },
      builder: (context) => ValueListenableBuilder<int>(
        valueListenable: _indexNotifier,
        builder: (context, selectedIndex, child) {
          return _MainScreenContent(
            selectedIndex: selectedIndex,
            onItemTapped: _onItemTapped,
            addTransactionKey: _addTransactionKey,
            categoriesTabKey: _categoriesTabKey,
            addCategoryKey: _addCategoryKey,
            reportsTabKey: _reportsTabKey,
            reportsContentKey: _reportsContentKey,
          );
        },
      ),
    );
  }
}

class _MainScreenContent extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final GlobalKey addTransactionKey;
  final GlobalKey categoriesTabKey;
  final GlobalKey addCategoryKey;
  final GlobalKey reportsTabKey;
  final GlobalKey reportsContentKey;

  const _MainScreenContent({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.addTransactionKey,
    required this.categoriesTabKey,
    required this.addCategoryKey,
    required this.reportsTabKey,
    required this.reportsContentKey,
  });

  @override
  State<_MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<_MainScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tutorialProvider = Provider.of<TutorialProvider>(
        context,
        listen: false,
      );
      if (!tutorialProvider.isTutorialCompleted) {
        ShowCaseWidget.of(context).startShowCase([
          widget.addTransactionKey,
          widget.categoriesTabKey,
          widget.addCategoryKey,
          widget.reportsTabKey,
          widget.reportsContentKey,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: widget.selectedIndex,
        children: [
          HomeScreen(addTransactionKey: widget.addTransactionKey),
          CategoryScreen(addCategoryKey: widget.addCategoryKey),
          ReportsScreen(reportsContentKey: widget.reportsContentKey),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.categoriesTabKey,
              title: l10n.tutorialCategoriesTabTitle,
              description: l10n.tutorialCategoriesTabDesc,
              onTargetClick: () {
                widget.onItemTapped(1);
              },
              disposeOnTap: true,
              child: const Icon(Icons.dataset),
            ),
            label: l10n.categories,
          ),
          BottomNavigationBarItem(
            icon: Showcase(
              key: widget.reportsTabKey,
              title: l10n.tutorialReportsTabTitle,
              description: l10n.tutorialReportsTabDesc,
              onTargetClick: () {
                widget.onItemTapped(2);
              },
              disposeOnTap: true,
              child: const Icon(Icons.pie_chart),
            ),
            label: l10n.reports,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
