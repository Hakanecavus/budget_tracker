import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:showcaseview/showcaseview.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bottom_sheet_wrapper.dart';
import '../widgets/delete_dismissible_background.dart';
import '../widgets/dialogs.dart';

class CategoryScreen extends StatefulWidget {
  final GlobalKey? addCategoryKey;
  const CategoryScreen({super.key, this.addCategoryKey});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    final incomeCategories = categoryProvider.categories
        .where((cat) => cat.type == CategoryType.income)
        .toList();
    final expenseCategories = categoryProvider.categories
        .where((cat) => cat.type == CategoryType.expense)
        .toList();

    final categories = _currentTabIndex == 0
        ? incomeCategories
        : expenseCategories;

    final appBarTheme = Theme.of(context).appBarTheme;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          l10n.categories,
          style: TextStyle(color: appBarTheme.foregroundColor),
        ),
        transitionBetweenRoutes: false,
        border: null,
        backgroundColor: appBarTheme.backgroundColor,
        trailing: Showcase(
          key: widget.addCategoryKey ?? GlobalKey(),
          title: l10n.tutorialAddCategoryTitle,
          description: l10n.tutorialAddCategoryDesc,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add, color: appBarTheme.foregroundColor),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ),
      ),
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: Column(
            children: [
              Expanded(
                child: _buildCategoryList(categories, categoryProvider, l10n),
              ),
              CupertinoTabBar(
                currentIndex: _currentTabIndex,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.arrow_up_circle),
                    label: l10n.income,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.arrow_down_circle),
                    label: l10n.expense,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    List<Category> categories,
    CategoryProvider categoryProvider,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Dismissible(
          key: Key(category.id),
          direction: DismissDirection.endToStart,
          background: const DeleteDismissibleBackground(),
          confirmDismiss: (direction) async {
            return await showDeleteConfirmationDialog(
              context: context,
              title: l10n.confirmDelete,
              content: l10n.confirmDeleteCategory(category.name),
              deleteText: l10n.delete,
              cancelText: l10n.cancel,
            );
          },
          onDismissed: (direction) {
            categoryProvider.deleteCategory(category.id);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${category.name} deleted')));
          },
          child: ListTile(
            leading: CircleAvatar(backgroundColor: category.color, radius: 10),
            title: Text(
              category.id.startsWith('unknown_') ? l10n.unknown : category.name,
            ),
            subtitle: Text(
              category.type == CategoryType.income ? l10n.income : l10n.expense,
            ),
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCategorySheet(),
    );
  }
}

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;
  CategoryType _selectedType = CategoryType.expense;

  // ... colors definition ...
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty) return;

    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final uuid = Uuid();
    final newCategory = Category(
      id: uuid.v4(),
      name: _nameController.text,
      color: _selectedColor,
      type: _selectedType,
    );
    categoryProvider.addCategory(newCategory);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomSheetWrapper(
      title: l10n.addCategory,
      onClose: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Input
          CupertinoTextField(
            controller: _nameController,
            placeholder: l10n.categoryName,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),

          // Type Segmented Control
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl<CategoryType>(
              groupValue: _selectedType,
              children: {
                CategoryType.income: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  child: Text(l10n.income),
                ),
                CategoryType.expense: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  child: Text(l10n.expense),
                ),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ),
          const SizedBox(height: 24),

          // Color Picker Title
          Text(
            l10n.color,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Horizontal Color List
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final color = _colors[index];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: isDark ? Colors.white : Colors.black,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: isDark ? Colors.black : Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          // Add Button
          ElevatedButton(
            onPressed: _nameController.text.isNotEmpty ? _submit : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(
              l10n.add,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
