import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/settings_model.dart';
import 'database_service.dart';

class StorageService {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<void> init() async {
    // Database is initialized automatically when first accessed
  }

  // Transaction methods
  static Future<void> saveTransaction(TransactionModel transaction) async {
    await _databaseService.insertTransaction(transaction);
  }

  static Future<void> updateTransaction(TransactionModel transaction) async {
    await _databaseService.updateTransaction(transaction);
  }

  static Future<void> deleteTransaction(String id) async {
    await _databaseService.deleteTransaction(id);
  }

  static Future<List<TransactionModel>> getTransactions() async {
    return await _databaseService.getTransactions();
  }

  // Budget methods
  static Future<void> saveBudget(BudgetModel budget) async {
    await _databaseService.saveBudget(budget);
  }

  static Future<List<BudgetModel>> getBudgets() async {
    return await _databaseService.getBudgets();
  }

  static Future<void> deleteBudget(String category, DateTime monthYear) async {
    await _databaseService.deleteBudget(category, monthYear);
  }

  // Settings methods
  static Future<void> saveSettings(SettingsModel settings) async {
    await _databaseService.saveSettings(settings);
  }

  static Future<SettingsModel> getSettings() async {
    return await _databaseService.getSettings();
  }

  static Future<void> clearAllData() async {
    await _databaseService.clearAllData();
  }
}