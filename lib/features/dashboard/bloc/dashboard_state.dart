part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final Map<dynamic, double> expensesByCategory;
  final List<TransactionModel> recentTransactions;
  final Map<dynamic, double> budgetUtilization;
  final String? error;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.balance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.expensesByCategory = const {},
    this.recentTransactions = const [],
    this.budgetUtilization = const {},
    this.error,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    double? balance,
    double? totalIncome,
    double? totalExpenses,
    Map<dynamic, double>? expensesByCategory,
    List<TransactionModel>? recentTransactions,
    Map<dynamic, double>? budgetUtilization,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      budgetUtilization: budgetUtilization ?? this.budgetUtilization,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        balance,
        totalIncome,
        totalExpenses,
        expensesByCategory,
        recentTransactions,
        budgetUtilization,
        error,
      ];
}