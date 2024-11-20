import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountModel with ChangeNotifier {
  final SupabaseClient supabaseClient;

  AccountModel({required this.supabaseClient}) {
    // Listen for authentication state changes
    supabaseClient.auth.onAuthStateChange.listen((event) {
      if (event.event == AuthChangeEvent.signedIn) {
        fetchAccounts(); // Fetch accounts when user signs in
      } else if (event.event == AuthChangeEvent.signedOut) {
        _accounts.clear(); // Clear accounts when user signs out
        notifyListeners();
      }
    });
  }

  final List<Map<String, dynamic>> _incomeEntries = [];
  final List<Map<String, dynamic>> _expenseEntries = [];

  // Supabase-backed accounts list
  List<Map<String, dynamic>> _accounts = [];

  List<Map<String, dynamic>> get accounts => List.unmodifiable(_accounts);
  List<Map<String, dynamic>> get incomeEntries =>
      List.unmodifiable(_incomeEntries);
  List<Map<String, dynamic>> get expenseEntries =>
      List.unmodifiable(_expenseEntries);

  /// Fetch all accounts for the current user
  Future<void> fetchAccounts() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      final response = await supabaseClient
          .from('accounts')
          .select()
          .eq('user_id', userId) // Filter by user_id
          .execute();

      if (response.status == 200 && response.data != null) {
        _accounts = List<Map<String, dynamic>>.from(response.data);
        notifyListeners(); // Notify listeners of the updated data
      }
    } catch (e) {
      debugPrint('Error fetching accounts: $e');
    }
  }

  /// Add a new account for the current user
  Future<void> addAccount(String type, double balance) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('No user is currently authenticated.');
      return;
    }

    try {
      await supabaseClient.from('accounts').insert({
        'type': type,
        'balance': balance,
        'ignored': false,
        'user_id': userId, // Include user_id
      }).execute();

      await fetchAccounts(); // Refresh local accounts list
    } catch (e) {
      debugPrint('Error adding account: $e');
    }
  }

  /// Update an account in Supabase
  Future<void> updateAccount(int index, String type, double balance) async {
    if (index >= 0 && index < _accounts.length) {
      final id = _accounts[index]['id'];

      try {
        await supabaseClient
            .from('accounts')
            .update({'type': type, 'balance': balance})
            .eq('id', id)
            .execute();

        await fetchAccounts(); // Refresh local accounts list
      } catch (e) {
        debugPrint('Error updating account: $e');
      }
    }
  }

  /// Delete an account from Supabase
  Future<void> deleteAccount(int index) async {
    if (index >= 0 && index < _accounts.length) {
      final id = _accounts[index]['id'];

      try {
        await supabaseClient.from('accounts').delete().eq('id', id).execute();
        await fetchAccounts(); // Refresh local accounts list
      } catch (e) {
        debugPrint('Error deleting account: $e');
      }
    }
  }

  /// Toggle the "ignored" state of an account in Supabase
  Future<void> toggleIgnore(int index) async {
    if (index >= 0 && index < _accounts.length) {
      final id = _accounts[index]['id'];
      final currentState = _accounts[index]['ignored'];

      try {
        await supabaseClient
            .from('accounts')
            .update({'ignored': !currentState})
            .eq('id', id)
            .execute();

        await fetchAccounts(); // Refresh local accounts list
      } catch (e) {
        debugPrint('Error toggling ignored state: $e');
      }
    }
  }

  /// Method to get account by name (local filter)
  Map<String, dynamic>? getAccountByName(String accountName) {
    return _accounts.firstWhere(
      (account) => account['type'] == accountName,
      orElse: () => {}, // Return an empty map if no account is found
    ) as Map<String, dynamic>?; // Cast to the expected type
  }

  // Income and Expense methods remain unchanged

  void addIncome(String category, double amount) {
    _incomeEntries.add({'category': category, 'amount': amount});
    notifyListeners();
  }

  void addExpense(String category, double amount) {
    _expenseEntries.add({'category': category, 'amount': amount});
    notifyListeners();
  }

  List<Map<String, dynamic>> getIncomes() {
    return _incomeEntries;
  }

  List<Map<String, dynamic>> getExpenses() {
    return _expenseEntries;
  }
}
