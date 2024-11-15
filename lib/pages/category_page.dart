import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_model.dart'; // Import the shared CategoryModel
import 'add_entry_page.dart'; // Import the calculator (AddEntryPage)

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final categoryModel = Provider.of<CategoryModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySection(
                'Income Categories',
                categoryModel.incomeCategories,
              ),
              _buildCategorySection(
                'Expense Categories',
                categoryModel.expenseCategories,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddCategoryDialog(context, categoryModel);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ADD NEW CATEGORY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    minimumSize: const Size(180, 60),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEntryPage()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<Map<String, dynamic>> categories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        ...categories.map((category) {
          return _buildCategoryTileWithActions(category);
        }),
      ],
    );
  }

  Widget _buildCategoryTileWithActions(Map<String, dynamic> category) {
    bool isIgnored = category['ignored'] ?? false;
    return Opacity(
      opacity: isIgnored ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          leading: Icon(category['icon'], size: 40),
          title: Text(
            category['name'],
            style: TextStyle(
              fontSize: 18,
              decoration: isIgnored ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Edit':
                  _showEditCategoryDialog(context, category);
                  break;
                case 'Delete':
                  _showDeleteConfirmationDialog(context, category['name']);
                  break;
                case 'Ignore':
                  setState(() {
                    category['ignored'] = true;
                  });
                  break;
                case 'Restore':
                  setState(() {
                    category['ignored'] = false;
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'Delete',
                child: Text('Delete'),
              ),
              PopupMenuItem<String>(
                value: isIgnored ? 'Restore' : 'Ignore',
                child: Text(isIgnored ? 'Restore' : 'Ignore'),
              ),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(
      BuildContext context, CategoryModel categoryModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          onSave: (String name, IconData icon, bool isIncomeCategory) {
            categoryModel.addCategory(name, icon, isIncomeCategory);
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(
      BuildContext context, Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          initialCategory: category,
          onSave: (String name, IconData icon, bool isIncomeCategory) {
            setState(() {
              category['name'] = name;
              category['icon'] = icon;
              category['isIncome'] = isIncomeCategory;
            });
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this category?'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<CategoryModel>(context, listen: false)
                    .removeCategory(categoryName);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  final Map<String, dynamic>? initialCategory;
  final Function(String, IconData, bool) onSave;

  const AddCategoryDialog({
    this.initialCategory,
    required this.onSave,
    super.key,
  });

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _nameController;
  int _selectedIconIndex = 0;
  bool isIncomeCategory = true;

  final List<IconData> _iconOptions = [
    Icons.card_giftcard,
    Icons.local_offer,
    Icons.grading,
    Icons.confirmation_number,
    Icons.school,
    Icons.devices,
    Icons.movie,
    Icons.fastfood,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text:
          widget.initialCategory != null ? widget.initialCategory!['name'] : '',
    );
    _selectedIconIndex = _iconOptions
        .indexOf(widget.initialCategory?['icon'] ?? Icons.card_giftcard);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialCategory != null
          ? 'Edit Category'
          : 'Add New Category'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Category Type Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Type:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                GestureDetector(
                  onTap: () => setState(() => isIncomeCategory = true),
                  child: Row(
                    children: [
                      Icon(
                        isIncomeCategory
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isIncomeCategory ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text('INCOME', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => isIncomeCategory = false),
                  child: Row(
                    children: [
                      Icon(
                        !isIncomeCategory
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: !isIncomeCategory ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text('EXPENSE', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Icon Selection
            const Text('Choose an Icon',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(_iconOptions.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedIconIndex = index),
                  child: Icon(
                    _iconOptions[index],
                    size: 40,
                    color:
                        _selectedIconIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              _nameController.text,
              _iconOptions[_selectedIconIndex],
              isIncomeCategory,
            );
            Navigator.pop(context);
          },
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
