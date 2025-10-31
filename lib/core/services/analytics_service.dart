import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../constants/category_constants.dart';
import '../../shared/enums/transaction_type.dart'; // Fixed import path

class AnalyticsService {
  static double calculateTotalBalance(List<TransactionModel> transactions) {
    double income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    return income - expenses;
  }

  static double calculateTotalIncome(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateTotalExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<Category, double> getExpensesByCategory(
    List<TransactionModel> transactions,
  ) {
    final Map<Category, double> categoryExpenses = {};
    
    for (final category in Category.all) {
      categoryExpenses[category] = 0.0;
    }
    
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        categoryExpenses[transaction.category] = 
            (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryExpenses;
  }

  static List<TransactionModel> getRecentTransactions(
    List<TransactionModel> transactions, {
    int count = 5,
  }) {
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(count).toList();
  }

  static Map<Category, double> getBudgetUtilization(
    List<TransactionModel> transactions,
    List<BudgetModel> budgets,
  ) {
    final Map<Category, double> utilization = {};
    final expensesByCategory = getExpensesByCategory(transactions);
    
    for (final budget in budgets) {
      final spent = expensesByCategory[budget.category] ?? 0.0;
      if (budget.monthlyLimit > 0) {
        utilization[budget.category] = spent / budget.monthlyLimit;
      }
    }
    
    return utilization;
  }

  static bool isOverBudget(
    Category category,
    List<TransactionModel> transactions,
    List<BudgetModel> budgets,
  ) {
    final utilization = getBudgetUtilization(transactions, budgets);
    return (utilization[category] ?? 0.0) > 1.0;
  }
}