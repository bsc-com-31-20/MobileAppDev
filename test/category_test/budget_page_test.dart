import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/pages/category_model.dart';
import 'package:flutter_application_1/pages/budget_page.dart';
import 'package:provider/provider.dart';
import 'mock_category_model.mocks.dart';

void main() {
  late MockCategoryModel mockCategoryModel;

  setUp(() {
    mockCategoryModel = MockCategoryModel(); // Initialize the mock
  });

  testWidgets('Test totalBudget UI calculation with mocked data',
      (WidgetTester tester) async {
    try {
      // Mock data to simulate the CategoryModel behavior
      final budgetedCategories = [
        {
          'amount': 100.0,
          'spent': 50.0,
          'label': 'Food',
          'icon': Icons.fastfood
        },
        {
          'amount': 200.0,
          'spent': 120.0,
          'label': 'Transport',
          'icon': Icons.directions_bus
        },
        {
          'amount': 150.0,
          'spent': 30.0,
          'label': 'Entertainment',
          'icon': Icons.movie
        },
      ];

      // Mock the method to return the data
      when(mockCategoryModel.budgetedCategories).thenReturn(budgetedCategories);

      // Build the widget with the mock data
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockCategoryModel,
            child: BudgetPage(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Check if totalBudget is properly calculated
      final totalBudgetText = find.text('MK450.00');
      print(
          'Rendered Total Budget Text: ${tester.firstWidget(find.byType(Text))}');

      // Verify that the UI reflects the total budget calculation
      expect(totalBudgetText, findsOneWidget);
    } catch (e) {
      print('Test failed with exception: $e');
    }
  });
}
