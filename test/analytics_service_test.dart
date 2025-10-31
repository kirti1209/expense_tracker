import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/services/analytics_service.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/models/budget_model.dart';
import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:expense_tracker/shared/enums/transaction_type.dart';

void main() {
  group('AnalyticsService', () {
    final testDate = DateTime(2024, 1, 15);

    group('calculateTotalBalance', () {
      test('should return 0 for empty transactions', () {
        expect(AnalyticsService.calculateTotalBalance([]), 0.0);
      });

      test('should calculate balance correctly with income and expenses', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income',
            amount: 1000.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
          TransactionModel(
            id: '2',
            title: 'Expense 1',
            amount: 300.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '3',
            title: 'Expense 2',
            amount: 200.0,
            date: testDate,
            category: Category.travel,
            type: TransactionType.expense,
          ),
        ];

        expect(AnalyticsService.calculateTotalBalance(transactions), 500.0);
      });

      test('should return negative balance when expenses exceed income', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income',
            amount: 100.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
          TransactionModel(
            id: '2',
            title: 'Expense',
            amount: 500.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        expect(AnalyticsService.calculateTotalBalance(transactions), -400.0);
      });

      test('should handle only income transactions', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income 1',
            amount: 500.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
          TransactionModel(
            id: '2',
            title: 'Income 2',
            amount: 300.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
        ];

        expect(AnalyticsService.calculateTotalBalance(transactions), 800.0);
      });

      test('should handle only expense transactions', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Expense 1',
            amount: 100.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '2',
            title: 'Expense 2',
            amount: 200.0,
            date: testDate,
            category: Category.travel,
            type: TransactionType.expense,
          ),
        ];

        expect(AnalyticsService.calculateTotalBalance(transactions), -300.0);
      });
    });

    group('calculateTotalIncome', () {
      test('should return 0 for empty transactions', () {
        expect(AnalyticsService.calculateTotalIncome([]), 0.0);
      });

      test('should sum only income transactions', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income 1',
            amount: 500.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
          TransactionModel(
            id: '2',
            title: 'Expense',
            amount: 300.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '3',
            title: 'Income 2',
            amount: 200.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
        ];

        expect(AnalyticsService.calculateTotalIncome(transactions), 700.0);
      });
    });

    group('calculateTotalExpenses', () {
      test('should return 0 for empty transactions', () {
        expect(AnalyticsService.calculateTotalExpenses([]), 0.0);
      });

      test('should sum only expense transactions', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income',
            amount: 1000.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
          TransactionModel(
            id: '2',
            title: 'Expense 1',
            amount: 150.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '3',
            title: 'Expense 2',
            amount: 250.0,
            date: testDate,
            category: Category.travel,
            type: TransactionType.expense,
          ),
        ];

        expect(AnalyticsService.calculateTotalExpenses(transactions), 400.0);
      });
    });

    group('getExpensesByCategory', () {
      test('should return empty map for no transactions', () {
        final result = AnalyticsService.getExpensesByCategory([]);
        expect(result.isEmpty, false); // Should initialize all categories
        for (final category in Category.all) {
          expect(result[category], 0.0);
        }
      });

      test('should group expenses by category correctly', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense 1',
            amount: 50.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '2',
            title: 'Food Expense 2',
            amount: 75.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '3',
            title: 'Travel Expense',
            amount: 200.0,
            date: testDate,
            category: Category.travel,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '4',
            title: 'Income',
            amount: 500.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.income,
          ),
        ];

        final result = AnalyticsService.getExpensesByCategory(transactions);

        expect(result[Category.food], 125.0);
        expect(result[Category.travel], 200.0);
        expect(result[Category.other], 0.0); // Income should not be counted
      });

      test('should ignore income transactions', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Income',
            amount: 1000.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.income,
          ),
        ];

        final result = AnalyticsService.getExpensesByCategory(transactions);
        expect(result[Category.food], 0.0);
      });
    });

    group('getRecentTransactions', () {
      test('should return empty list for no transactions', () {
        expect(AnalyticsService.getRecentTransactions([]), isEmpty);
      });

      test('should return transactions sorted by date (newest first)', () {
        final date1 = DateTime(2024, 1, 10);
        final date2 = DateTime(2024, 1, 15);
        final date3 = DateTime(2024, 1, 20);

        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Oldest',
            amount: 100.0,
            date: date1,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '2',
            title: 'Newest',
            amount: 200.0,
            date: date3,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '3',
            title: 'Middle',
            amount: 150.0,
            date: date2,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final recent = AnalyticsService.getRecentTransactions(transactions, count: 3);

        expect(recent.length, 3);
        expect(recent[0].title, 'Newest');
        expect(recent[1].title, 'Middle');
        expect(recent[2].title, 'Oldest');
      });

      test('should limit to specified count', () {
        final transactions = List.generate(10, (index) {
          return TransactionModel(
            id: '$index',
            title: 'Transaction $index',
            amount: 100.0,
            date: DateTime(2024, 1, index + 1),
            category: Category.food,
            type: TransactionType.expense,
          );
        });

        final recent = AnalyticsService.getRecentTransactions(transactions, count: 5);

        expect(recent.length, 5);
      });

      test('should use default count of 5', () {
        final transactions = List.generate(10, (index) {
          return TransactionModel(
            id: '$index',
            title: 'Transaction $index',
            amount: 100.0,
            date: DateTime(2024, 1, index + 1),
            category: Category.food,
            type: TransactionType.expense,
          );
        });

        final recent = AnalyticsService.getRecentTransactions(transactions);

        expect(recent.length, 5);
      });
    });

    group('getBudgetUtilization', () {
      test('should return empty map when no budgets', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Expense',
            amount: 100.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final result = AnalyticsService.getBudgetUtilization(transactions, []);

        expect(result.isEmpty, true);
      });

      test('should calculate utilization correctly', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 150.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        final result = AnalyticsService.getBudgetUtilization(transactions, budgets);

        expect(result[Category.food], 0.3); // 150 / 500 = 0.3
      });

      test('should return 0 utilization when no expenses for budget category', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Other Expense',
            amount: 100.0,
            date: testDate,
            category: Category.other,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        final result = AnalyticsService.getBudgetUtilization(transactions, budgets);

        expect(result[Category.food], 0.0);
      });

      test('should handle over-budget scenario', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 600.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        final result = AnalyticsService.getBudgetUtilization(transactions, budgets);

        expect(result[Category.food], 1.2); // 600 / 500 = 1.2 (over budget)
      });

      test('should handle multiple budgets', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 200.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
          TransactionModel(
            id: '2',
            title: 'Travel Expense',
            amount: 400.0,
            date: testDate,
            category: Category.travel,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
          BudgetModel(
            category: Category.travel,
            monthlyLimit: 1000.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        final result = AnalyticsService.getBudgetUtilization(transactions, budgets);

        expect(result[Category.food], 0.4); // 200 / 500
        expect(result[Category.travel], 0.4); // 400 / 1000
      });
    });

    group('isOverBudget', () {
      test('should return false when under budget', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 200.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        expect(AnalyticsService.isOverBudget(Category.food, transactions, budgets), false);
      });

      test('should return true when over budget', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 600.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        expect(AnalyticsService.isOverBudget(Category.food, transactions, budgets), true);
      });

      test('should return false when exactly at budget', () {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Food Expense',
            amount: 500.0,
            date: testDate,
            category: Category.food,
            type: TransactionType.expense,
          ),
        ];

        final budgets = [
          BudgetModel(
            category: Category.food,
            monthlyLimit: 500.0,
            monthYear: DateTime(2024, 1, 1),
          ),
        ];

        expect(AnalyticsService.isOverBudget(Category.food, transactions, budgets), false);
      });
    });
  });
}

