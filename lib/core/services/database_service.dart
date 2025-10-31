import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/settings_model.dart';
import '../constants/category_constants.dart';
import '../../shared/enums/transaction_type.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT
      )
    ''');

    // Create budgets table
    await db.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        monthly_limit REAL NOT NULL,
        month_year TEXT NOT NULL,
        UNIQUE(category, month_year)
      )
    ''');

    // Create settings table
    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_dark_mode INTEGER NOT NULL DEFAULT 0,
        currency TEXT NOT NULL DEFAULT '\$'
      )
    ''');

    // Insert default settings
    await db.insert('settings', {
      'is_dark_mode': 0,
      'currency': '\$'
    });
  }

  // Transaction methods
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromJson(maps[i]);
    });
  }

  // Budget methods
  Future<void> saveBudget(BudgetModel budget) async {
    final db = await database;
    await db.insert(
      'budgets',
      budget.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BudgetModel>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');

    return List.generate(maps.length, (i) {
      return BudgetModel.fromJson(maps[i]);
    });
  }

  Future<void> deleteBudget(String category, DateTime monthYear) async {
    final db = await database;
    await db.delete(
      'budgets',
      where: 'category = ? AND month_year = ?',
      whereArgs: [category, monthYear.toIso8601String()],
    );
  }

  // Settings methods
  Future<void> saveSettings(SettingsModel settings) async {
    final db = await database;
    await db.update(
      'settings',
      settings.toJson(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<SettingsModel> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isEmpty) {
      return SettingsModel();
    }

    return SettingsModel.fromJson(maps.first);
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('transactions');
    await db.delete('budgets');
    // Reset settings to default
    await db.update(
      'settings',
      SettingsModel().toJson(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}