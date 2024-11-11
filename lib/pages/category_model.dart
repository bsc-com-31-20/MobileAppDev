import 'package:flutter/material.dart';

class CategoryModel extends ChangeNotifier {
  // Lists to store income and expense categories
  final List<Map<String, dynamic>> _incomeCategories = [
    {'icon': Icons.card_giftcard, 'name': 'Awards', 'ignored': false},
    {'icon': Icons.local_offer, 'name': 'Coupons', 'ignored': false},
    {'icon': Icons.grading, 'name': 'Grants', 'ignored': false},
    {'icon': Icons.confirmation_number, 'name': 'Lottery', 'ignored': false},
  ];

  final List<Map<String, dynamic>> _expenseCategories = [
    {'icon': Icons.school, 'name': 'Education', 'ignored': false},
    {'icon': Icons.devices, 'name': 'Electronics', 'ignored': false},
    {'icon': Icons.movie, 'name': 'Entertainment', 'ignored': false},
    {'icon': Icons.fastfood, 'name': 'Food', 'ignored': false},
  ];

  // Getters to access the categories
  List<Map<String, dynamic>> get incomeCategories => _incomeCategories;
  List<Map<String, dynamic>> get expenseCategories => _expenseCategories;

  // Method to add a new category to the appropriate list
  void addCategory(String name, IconData icon, bool isIncomeCategory) {
    final newCategory = {
      'icon': icon,
      'name': name,
      'ignored': false,
    };

    if (isIncomeCategory) {
      _incomeCategories.add(newCategory);
    } else {
      _expenseCategories.add(newCategory);
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to remove a category by name
  void removeCategory(String name) {
    _incomeCategories.removeWhere((category) => category['name'] == name);
    _expenseCategories.removeWhere((category) => category['name'] == name);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to update the ignored status of a category
  void toggleCategoryIgnore(String name, bool isIncomeCategory, bool ignore) {
    final categoryList =
        isIncomeCategory ? _incomeCategories : _expenseCategories;
    final category = categoryList.firstWhere((item) => item['name'] == name,
        orElse: () => {});
    if (category.isNotEmpty) {
      category['ignored'] = ignore;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
