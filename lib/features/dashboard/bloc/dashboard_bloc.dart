import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/analytics_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    
    try {
      final transactions = await StorageService.getTransactions();
      final budgets = await StorageService.getBudgets();
      
      final balance = AnalyticsService.calculateTotalBalance(transactions);
      final income = AnalyticsService.calculateTotalIncome(transactions);
      final expenses = AnalyticsService.calculateTotalExpenses(transactions);
      final expensesByCategory = AnalyticsService.getExpensesByCategory(transactions);
      final recentTransactions = AnalyticsService.getRecentTransactions(transactions);
      final budgetUtilization = AnalyticsService.getBudgetUtilization(transactions, budgets);

      emit(state.copyWith(
        status: DashboardStatus.success,
        balance: balance,
        totalIncome: income,
        totalExpenses: expenses,
        expensesByCategory: expensesByCategory,
        recentTransactions: recentTransactions,
        budgetUtilization: budgetUtilization,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        error: 'Failed to load dashboard data: $e',
      ));
    }
  }
}