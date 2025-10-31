import 'package:expense_tracker/core/constants/category_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/analytics_service.dart';

part 'budgets_event.dart';
part 'budgets_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  BudgetsBloc() : super(const BudgetsState()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetsState> emit,
  ) async {
    emit(state.copyWith(status: BudgetsStatus.loading));
    
    try {
      final budgets = await StorageService.getBudgets();
      final transactions = await StorageService.getTransactions();
      final budgetUtilization = AnalyticsService.getBudgetUtilization(transactions, budgets);

      emit(state.copyWith(
        budgets: budgets,
        budgetUtilization: budgetUtilization,
        status: BudgetsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BudgetsStatus.failure,
        error: 'Failed to load budgets: $e',
      ));
    }
  }

  Future<void> _onAddBudget(
    AddBudget event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await StorageService.saveBudget(event.budget);
      final budgets = await StorageService.getBudgets();
      final transactions = await StorageService.getTransactions();
      final budgetUtilization = AnalyticsService.getBudgetUtilization(transactions, budgets);

      emit(state.copyWith(
        budgets: budgets,
        budgetUtilization: budgetUtilization,
        status: BudgetsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BudgetsStatus.failure,
        error: 'Failed to add budget: $e',
      ));
    }
  }

  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetsState> emit,
  ) async {
    try {
      await StorageService.saveBudget(event.budget);
      final budgets = await StorageService.getBudgets();
      final transactions = await StorageService.getTransactions();
      final budgetUtilization = AnalyticsService.getBudgetUtilization(transactions, budgets);

      emit(state.copyWith(
        budgets: budgets,
        budgetUtilization: budgetUtilization,
        status: BudgetsStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BudgetsStatus.failure,
        error: 'Failed to update budget: $e',
      ));
    }
  }

  Future<void> _onDeleteBudget(
  DeleteBudget event,
  Emitter<BudgetsState> emit,
) async {
  try {
    await StorageService.deleteBudget(event.budget.category.name, event.budget.monthYear);
    final budgets = await StorageService.getBudgets();
    final transactions = await StorageService.getTransactions();
    final budgetUtilization = AnalyticsService.getBudgetUtilization(transactions, budgets);

    emit(state.copyWith(
      budgets: budgets,
      budgetUtilization: budgetUtilization,
      status: BudgetsStatus.success,
    ));
  } catch (e) {
    emit(state.copyWith(
      status: BudgetsStatus.failure,
      error: 'Failed to delete budget: $e',
    ));
  }
}
}