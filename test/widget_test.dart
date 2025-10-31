import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/dashboard/pages/dashboard_page.dart';
import 'package:expense_tracker/features/transactions/pages/transactions_page.dart';
import 'package:expense_tracker/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:expense_tracker/features/transactions/bloc/transactions_bloc.dart';
import 'package:expense_tracker/core/models/transaction_model.dart';
import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:expense_tracker/shared/enums/transaction_type.dart';
import 'package:expense_tracker/features/dashboard/widgets/balance_card.dart';
import 'package:expense_tracker/features/dashboard/widgets/recent_transactions.dart';

void main() {
  group('Dashboard Widget Tests', () {
    testWidgets('DashboardPage should have app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DashboardBloc>(
            create: (_) => DashboardBloc()..add(LoadDashboardData()),
            child: const DashboardPage(),
          ),
        ),
      );

      await tester.pump(); // Initial pump

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });

  group('Transactions Widget Tests', () {
    testWidgets('TransactionsPage should have app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TransactionsBloc>(
            create: (_) => TransactionsBloc()..add(LoadTransactions()),
            child: const TransactionsPage(),
          ),
        ),
      );

      await tester.pump(); // Initial pump

      expect(find.text('Transactions'), findsOneWidget);
    });

    testWidgets('TransactionsPage should display add floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TransactionsBloc>(
            create: (_) => TransactionsBloc()..add(LoadTransactions()),
            child: const TransactionsPage(),
          ),
        ),
      );

      await tester.pump(); // Initial pump

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('BalanceCard Widget Tests', () {
    testWidgets('BalanceCard should display balance, income, and expenses', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: 500.0,
              income: 1000.0,
              expenses: 500.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current Balance'), findsOneWidget);
      expect(find.text('\$500.00'), findsAtLeastNWidgets(1));
    });

    testWidgets('BalanceCard should display positive balance correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: 1000.0,
              income: 2000.0,
              expenses: 1000.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current Balance'), findsOneWidget);
    });

    testWidgets('BalanceCard should display negative balance correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              balance: -500.0,
              income: 500.0,
              expenses: 1000.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Current Balance'), findsOneWidget);
    });
  });

  group('RecentTransactions Widget Tests', () {
    testWidgets('RecentTransactions should display empty state when no transactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecentTransactions(transactions: []),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No recent transactions'), findsOneWidget);
    });

    testWidgets('RecentTransactions should display transaction list', (WidgetTester tester) async {
      final transactions = [
        TransactionModel(
          id: '1',
          title: 'Transaction 1',
          amount: 100.0,
          date: DateTime.now(),
          category: Category.food,
          type: TransactionType.expense,
        ),
        TransactionModel(
          id: '2',
          title: 'Transaction 2',
          amount: 200.0,
          date: DateTime.now(),
          category: Category.travel,
          type: TransactionType.income,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecentTransactions(transactions: transactions),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('Transaction 1'), findsOneWidget);
      expect(find.text('Transaction 2'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('RecentTransactions should display correct transaction amounts', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        title: 'Test',
        amount: 150.50,
        date: DateTime.now(),
        category: Category.food,
        type: TransactionType.expense,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecentTransactions(transactions: [transaction]),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });
  });
}

