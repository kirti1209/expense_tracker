import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:expense_tracker/shared/enums/transaction_type.dart';

void main() {
  group('TransactionModel', () {
    final testDate = DateTime(2024, 1, 15);
    final testTransaction = TransactionModel(
      id: 'test-1',
      title: 'Test Transaction',
      amount: 100.50,
      date: testDate,
      category: Category.food,
      type: TransactionType.expense,
      description: 'Test description',
    );

    test('should create a transaction with all fields', () {
      expect(testTransaction.id, 'test-1');
      expect(testTransaction.title, 'Test Transaction');
      expect(testTransaction.amount, 100.50);
      expect(testTransaction.date, testDate);
      expect(testTransaction.category, Category.food);
      expect(testTransaction.type, TransactionType.expense);
      expect(testTransaction.description, 'Test description');
    });

    test('should create a transaction without description', () {
      final transactionWithoutDesc = TransactionModel(
        id: 'test-2',
        title: 'No Description',
        amount: 50.0,
        date: testDate,
        category: Category.travel,
        type: TransactionType.income,
      );

      expect(transactionWithoutDesc.description, isNull);
    });

    test('should serialize to JSON correctly', () {
      final json = testTransaction.toJson();

      expect(json['id'], 'test-1');
      expect(json['title'], 'Test Transaction');
      expect(json['amount'], 100.50);
      expect(json['date'], testDate.toIso8601String());
      expect(json['category'], 'food');
      expect(json['type'], 'expense');
      expect(json['description'], 'Test description');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-3',
        'title': 'JSON Transaction',
        'amount': 75.25,
        'date': testDate.toIso8601String(),
        'category': 'bills',
        'type': 'expense',
        'description': 'JSON test',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.id, 'test-3');
      expect(transaction.title, 'JSON Transaction');
      expect(transaction.amount, 75.25);
      expect(transaction.date, testDate);
      expect(transaction.category, Category.bills);
      expect(transaction.type, TransactionType.expense);
      expect(transaction.description, 'JSON test');
    });

    test('should deserialize income transaction correctly', () {
      final json = {
        'id': 'test-4',
        'title': 'Income',
        'amount': 1000.0,
        'date': testDate.toIso8601String(),
        'category': 'other',
        'type': 'income',
        'description': null,
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.type, TransactionType.income);
      expect(transaction.description, isNull);
    });

    test('copyWith should create a new transaction with updated fields', () {
      final updated = testTransaction.copyWith(
        title: 'Updated Title',
        amount: 200.0,
        category: Category.shopping,
      );

      expect(updated.id, testTransaction.id); // unchanged
      expect(updated.title, 'Updated Title'); // changed
      expect(updated.amount, 200.0); // changed
      expect(updated.category, Category.shopping); // changed
      expect(updated.type, testTransaction.type); // unchanged
      expect(updated.date, testTransaction.date); // unchanged
    });

    test('copyWith should handle null description', () {
      final transactionWithDesc = testTransaction.copyWith(description: null);
      expect(transactionWithDesc.description, isNull);
    });

    test('equality should work correctly', () {
      final transaction1 = TransactionModel(
        id: 'same-id',
        title: 'Same',
        amount: 100.0,
        date: testDate,
        category: Category.food,
        type: TransactionType.expense,
      );

      final transaction2 = TransactionModel(
        id: 'same-id',
        title: 'Same',
        amount: 100.0,
        date: testDate,
        category: Category.food,
        type: TransactionType.expense,
      );

      expect(transaction1, equals(transaction2));
    });

    test('should not be equal when fields differ', () {
      final transaction1 = TransactionModel(
        id: 'id-1',
        title: 'Transaction 1',
        amount: 100.0,
        date: testDate,
        category: Category.food,
        type: TransactionType.expense,
      );

      final transaction2 = TransactionModel(
        id: 'id-2',
        title: 'Transaction 2',
        amount: 200.0,
        date: testDate,
        category: Category.food,
        type: TransactionType.expense,
      );

      expect(transaction1, isNot(equals(transaction2)));
    });
  });
}

