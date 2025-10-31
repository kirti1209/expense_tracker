part of 'budgets_bloc.dart';

enum BudgetsStatus { initial, loading, success, failure }

class BudgetsState extends Equatable {
  final List<BudgetModel> budgets;
  final Map<dynamic, double> budgetUtilization;
  final BudgetsStatus status;
  final String? error;

  const BudgetsState({
    this.budgets = const [],
    this.budgetUtilization = const {},
    this.status = BudgetsStatus.initial,
    this.error,
  });

  BudgetsState copyWith({
    List<BudgetModel>? budgets,
    Map<dynamic, double>? budgetUtilization,
    BudgetsStatus? status,
    String? error,
  }) {
    return BudgetsState(
      budgets: budgets ?? this.budgets,
      budgetUtilization: budgetUtilization ?? this.budgetUtilization,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [budgets, budgetUtilization, status, error];
}