import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryModel with ChangeNotifier {
  final SupabaseClient supabaseClient;

  CategoryModel({required this.supabaseClient}) {
    // Listen for authentication state changes
    supabaseClient.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        fetchCategories(); // Fetch categories when user signs in
      } else if (event.event == AuthChangeEvent.signedOut) {
        _incomeCategories.clear(); // Clear categories on sign out
        _expenseCategories.clear();
        notifyListeners();
      }
    });
  }

  // Lists to store categories fetched from the database
  List<Map<String, dynamic>> _incomeCategories = [];
  List<Map<String, dynamic>> _expenseCategories = [];
  final List<Map<String, dynamic>> _budgetedCategories = [];

  // Getters to access the categories
  List<Map<String, dynamic>> get incomeCategories =>
      List.unmodifiable(_incomeCategories);
  List<Map<String, dynamic>> get expenseCategories =>
      List.unmodifiable(_expenseCategories);
  List<Map<String, dynamic>> get budgetedCategories =>
      List.unmodifiable(_budgetedCategories);

  /// Fetch categories from the database
  Future<void> fetchCategories() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .eq('user_id', userId) // Filter by user_id
          .execute();

      if (response.status == 200 && response.data != null) {
        final categories = List<Map<String, dynamic>>.from(response.data);
        _incomeCategories = categories
            .where((category) => category['is_income'] == true)
            .toList();
        _expenseCategories = categories
            .where((category) => category['is_income'] == false)
            .toList();

        // Map icon codePoints back to IconData
        _incomeCategories.forEach((category) {
          category['icon'] =
              IconData(category['icon'], fontFamily: 'MaterialIcons');
        });
        _expenseCategories.forEach((category) {
          category['icon'] =
              IconData(category['icon'], fontFamily: 'MaterialIcons');
        });

        notifyListeners(); // Notify listeners to update the UI
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  /// Add a new category to the database
  Future<void> addCategory(
      String name, IconData icon, bool isIncomeCategory) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      final newCategory = {
        'name': name,
        'icon': icon.codePoint, // Store the codePoint of the icon
        'is_income': isIncomeCategory,
        'ignored': false,
        'user_id': userId,
      };

      await supabaseClient.from('categories').insert(newCategory).execute();
      await fetchCategories(); // Refresh categories after adding
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  /// Remove a category from the database
  Future<void> removeCategory(String name) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      await supabaseClient
          .from('categories')
          .delete()
          .eq('name', name)
          .eq('user_id', userId) // Ensure user-specific deletion
          .execute();

      await fetchCategories(); // Refresh categories after deletion
    } catch (e) {
      debugPrint('Error removing category: $e');
    }
  }

  /// Update the ignored status of a category
  Future<void> toggleCategoryIgnore(
      String name, bool isIncomeCategory, bool ignore) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      await supabaseClient
          .from('categories')
          .update({'ignored': ignore})
          .eq('name', name)
          .eq('user_id', userId)
          .execute();

      await fetchCategories(); // Refresh categories after update
    } catch (e) {
      debugPrint('Error toggling category ignore: $e');
    }
  }

  /// Add a budgeted category
  Future<void> addBudgetedCategory(Map<String, dynamic> category) async {
    final existingCategory = _budgetedCategories.firstWhere(
      (item) => item['label'] == category['label'],
      orElse: () => {},
    );

    if (existingCategory.isEmpty) {
      _budgetedCategories.add({
        'icon': category['icon'],
        'label': category['label'] ?? category['name'],
        'amount': category['amount'] ?? 0.0,
        'spent': category['spent'] ?? 0.0,
      });
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  /// Update the budget limit for a specific category
  void updateBudgetLimit(String label, double newLimit) {
    final category = _budgetedCategories.firstWhere(
      (item) => item['label'] == label,
      orElse: () => {},
    );
    if (category.isNotEmpty) {
      category['amount'] = newLimit;
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  /// Remove a budgeted category
  void removeBudgetedCategory(String label) {
    _budgetedCategories.removeWhere((category) => category['label'] == label);
    notifyListeners(); // Notify listeners to update the UI
  }

  /// Update the spent amount for a budgeted category
  void updateSpentAmount(String label, double spentAmount) {
    final category = _budgetedCategories.firstWhere(
      (item) => item['label'] == label,
      orElse: () => {},
    );
    if (category.isNotEmpty) {
      category['spent'] = (category['spent'] ?? 0.0) + spentAmount;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
