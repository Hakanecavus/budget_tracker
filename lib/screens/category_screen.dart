import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;
  CategoryType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categories),
      ),
      body: ListView.builder(
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];
          return Dismissible(
            key: Key(category.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete the category "${category.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              categoryProvider.deleteCategory(category.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${category.name} deleted')),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color,
                radius: 10,
              ),
              title: Text(category.id.startsWith('unknown_') ? l10n.unknown : category.name),
              subtitle: Text(category.type == CategoryType.income ? l10n.income : l10n.expense),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.addCategory),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: l10n.categoryName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('${l10n.type}:'),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<CategoryType>(
                                value: CategoryType.income,
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                              Text(l10n.income),
                              Radio<CategoryType>(
                                value: CategoryType.expense,
                                groupValue: _selectedType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                              Text(l10n.expense),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('${l10n.color}:'),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _selectColor(context, setState),
                          child: CircleAvatar(
                            backgroundColor: _selectedColor,
                            radius: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedType != null) {
                      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                      final uuid = Uuid();
                      final newCategory = Category(
                        id: uuid.v4(),
                        name: _nameController.text,
                        color: _selectedColor,
                        type: _selectedType!,
                      );
                      categoryProvider.addCategory(newCategory);
                      _nameController.clear();
                      _selectedColor = Colors.blue;
                      _selectedType = null;
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(l10n.add),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _selectColor(BuildContext context, StateSetter parentSetState) async {
    final l10n = AppLocalizations.of(context)!;
    Color tempSelectedColor = _selectedColor;

    final Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: Text(l10n.pickColor),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: tempSelectedColor,
                  onColorChanged: (color) {
                    dialogSetState(() {
                      tempSelectedColor = color;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(tempSelectedColor),
                  child: Text(l10n.select),
                ),
              ],
            );
          },
        );
      },
    );

    if (pickedColor != null) {
      parentSetState(() {
        _selectedColor = pickedColor;
      });
    }
  }
}

class ColorPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
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
      ].map((color) {
        final isSelected = pickerColor == color;
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.black, size: 16) : null,
          ),
        );
      }).toList(),
    );
  }
}