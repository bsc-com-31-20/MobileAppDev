// Mocks generated by Mockito 5.4.4 from annotations
// in flutter_application_1/test/test/mock_category_model.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i6;

import 'package:flutter/material.dart' as _i5;
import 'package:flutter_application_1/pages/category_model.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:supabase_flutter/supabase_flutter.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSupabaseClient_0 extends _i1.SmartFake
    implements _i2.SupabaseClient {
  _FakeSupabaseClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CategoryModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockCategoryModel extends _i1.Mock implements _i3.CategoryModel {
  MockCategoryModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SupabaseClient get supabaseClient => (super.noSuchMethod(
        Invocation.getter(#supabaseClient),
        returnValue: _FakeSupabaseClient_0(
          this,
          Invocation.getter(#supabaseClient),
        ),
      ) as _i2.SupabaseClient);

  @override
  List<Map<String, dynamic>> get incomeCategories => (super.noSuchMethod(
        Invocation.getter(#incomeCategories),
        returnValue: <Map<String, dynamic>>[],
      ) as List<Map<String, dynamic>>);

  @override
  List<Map<String, dynamic>> get expenseCategories => (super.noSuchMethod(
        Invocation.getter(#expenseCategories),
        returnValue: <Map<String, dynamic>>[],
      ) as List<Map<String, dynamic>>);

  @override
  List<Map<String, dynamic>> get budgetedCategories => (super.noSuchMethod(
        Invocation.getter(#budgetedCategories),
        returnValue: <Map<String, dynamic>>[],
      ) as List<Map<String, dynamic>>);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i4.Future<void> fetchCategories() => (super.noSuchMethod(
        Invocation.method(
          #fetchCategories,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addCategory(
    String? name,
    _i5.IconData? icon,
    bool? isIncomeCategory,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addCategory,
          [
            name,
            icon,
            isIncomeCategory,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeCategory(String? name) => (super.noSuchMethod(
        Invocation.method(
          #removeCategory,
          [name],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> toggleCategoryIgnore(
    String? name,
    bool? isIncomeCategory,
    bool? ignore,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #toggleCategoryIgnore,
          [
            name,
            isIncomeCategory,
            ignore,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addBudgetedCategory(Map<String, dynamic>? category) =>
      (super.noSuchMethod(
        Invocation.method(
          #addBudgetedCategory,
          [category],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void updateBudgetLimit(
    String? label,
    double? newLimit,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #updateBudgetLimit,
          [
            label,
            newLimit,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeBudgetedCategory(String? label) => super.noSuchMethod(
        Invocation.method(
          #removeBudgetedCategory,
          [label],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateSpentAmount(
    String? label,
    double? spentAmount,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #updateSpentAmount,
          [
            label,
            spentAmount,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
