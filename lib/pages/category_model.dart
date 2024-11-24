import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryModel with ChangeNotifier {
  final SupabaseClient supabaseClient;

  static const Map<int, IconData> iconMapping = {
    0: Icons.card_giftcard,
    1: Icons.local_offer,
    2: Icons.grading,
    3: Icons.confirmation_number,
    4: Icons.school,
    5: Icons.devices,
    6: Icons.movie,
    7: Icons.fastfood,
  };

  CategoryModel({required this.supabaseClient}) {
    supabaseClient.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        fetchCategories();
      } else if (event.event == AuthChangeEvent.signedOut) {
        _incomeCategories.clear();
        _expenseCategories.clear();
        notifyListeners();
      }
    });
  }

  List<Map<String, dynamic>> _incomeCategories = [];
  List<Map<String, dynamic>> _expenseCategories = [];
  final List<Map<String, dynamic>> _budgetedCategories = [];

  List<Map<String, dynamic>> get incomeCategories =>
      List.unmodifiable(_incomeCategories);
  List<Map<String, dynamic>> get expenseCategories =>
      List.unmodifiable(_expenseCategories);
  List<Map<String, dynamic>> get budgetedCategories =>
      List.unmodifiable(_budgetedCategories);

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
          .eq('user_id', userId)
          .execute();

      if (response.status == 200 && response.data != null) {
        final categories = List<Map<String, dynamic>>.from(response.data);
        _incomeCategories = categories
            .where((category) => category['is_income'] == true)
            .toList();
        _expenseCategories = categories
            .where((category) => category['is_income'] == false)
            .toList();

        _incomeCategories.forEach((category) {
          category['icon'] = iconMapping[category['iconId']] ?? Icons.help;
        });

        _expenseCategories.forEach((category) {
          category['icon'] = iconMapping[category['iconId']] ?? Icons.help;
        });

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

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
        'iconId': iconMapping.entries
            .firstWhere((entry) => entry.value == icon,
                orElse: () => MapEntry(0, Icons.help))
            .key,
        'is_income': isIncomeCategory,
        'ignored': false,
        'user_id': userId,
      };

      await supabaseClient.from('categories').insert(newCategory).execute();
      await fetchCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

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
          .eq('user_id', userId)
          .execute();

      await fetchCategories();
    } catch (e) {
      debugPrint('Error removing category: $e');
    }
  }

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

      await fetchCategories();
    } catch (e) {
      debugPrint('Error toggling category ignore: $e');
    }
  }

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
      notifyListeners();
    }
  }

  void updateBudgetLimit(String label, double newLimit) {
    final category = _budgetedCategories.firstWhere(
      (item) => item['label'] == label,
      orElse: () => {},
    );
    if (category.isNotEmpty) {
      category['amount'] = newLimit;
      notifyListeners();
    }
  }

  void removeBudgetedCategory(String label) {
    _budgetedCategories.removeWhere((category) => category['label'] == label);
    notifyListeners();
  }

  void updateSpentAmount(String label, double spentAmount) {
    final category = _budgetedCategories.firstWhere(
      (item) => item['label'] == label,
      orElse: () => {},
    );
    if (category.isNotEmpty) {
      category['spent'] = (category['spent'] ?? 0.0) + spentAmount;
      notifyListeners();
    }
  }
}
