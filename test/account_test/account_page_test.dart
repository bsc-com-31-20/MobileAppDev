import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/account_details_page.dart';
import 'package:flutter_application_1/pages/account_model.dart';
import 'package:flutter_application_1/pages/accounts_page.dart';
import 'package:flutter_application_1/pages/add_account_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mock_account_model.mocks.dart';

void main() {
  group('AccountsPage Tests', () {
    late MockAccountModel mockAccountModel;

    setUp(() {
      mockAccountModel = MockAccountModel();
    });

    testWidgets('displays the account balance correctly', (tester) async {
      // Mock the account model
      when(mockAccountModel.accounts).thenReturn([
        {'type': 'Savings', 'balance': 1000.0},
        {'type': 'Checking', 'balance': 500.0}
      ]);

      // Build the widget with a provider for AccountModel
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAccountModel,
            child: AccountsPage(),
          ),
        ),
      );

      // Verify that the total balance is calculated correctly
      expect(find.text('All Accounts MK1500.0'), findsOneWidget);
    });

    testWidgets('shows a message when there are no accounts', (tester) async {
      // Mock the account model with no accounts
      when(mockAccountModel.accounts).thenReturn([]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAccountModel,
            child: AccountsPage(),
          ),
        ),
      );

      // Verify that the "no accounts" message is shown
      expect(
        find.text("You don't have any accounts yet. Please add a new account."),
        findsOneWidget,
      );
    });
    // Other tests...
  });
}
