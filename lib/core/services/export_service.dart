import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import 'storage_service.dart';

class ExportService {
  static Future<void> exportToCSV() async {
    try {
      // Get all transactions
      final transactions = await StorageService.getTransactions();
      
      // Build CSV content
      final StringBuffer csvBuffer = StringBuffer();
      
      // CSV Header
      csvBuffer.writeln('Transaction Export');
      csvBuffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
      csvBuffer.writeln();
      
      // Transactions Section
      csvBuffer.writeln('Transactions,');
      csvBuffer.writeln('ID,Title,Amount,Date,Category,Type,Description');
      
      for (final transaction in transactions) {
        csvBuffer.writeln([
          transaction.id,
          _escapeCSV(transaction.title),
          transaction.amount.toStringAsFixed(2),
          transaction.date.toIso8601String(),
          transaction.category.name,
          transaction.type.name,
          _escapeCSV(transaction.description ?? ''),
        ].join(','));
      }
      
      csvBuffer.writeln();
      csvBuffer.writeln('Summary,');
      csvBuffer.writeln('Total Transactions,${transactions.length}');
      csvBuffer.writeln('Total Income,${_calculateIncome(transactions).toStringAsFixed(2)}');
      csvBuffer.writeln('Total Expenses,${_calculateExpenses(transactions).toStringAsFixed(2)}');
      csvBuffer.writeln('Balance,${(_calculateIncome(transactions) - _calculateExpenses(transactions)).toStringAsFixed(2)}');
      
      // Write to file
      final String csvContent = csvBuffer.toString();
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/expense_export_${DateTime.now().millisecondsSinceEpoch}.csv';
      final File file = File(filePath);
      await file.writeAsString(csvContent);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Expense Tracker Export',
        text: 'My expense tracker data export',
      );
      
      // Clean up file after sharing (optional)
      // await file.delete();
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }
  
  static String _escapeCSV(String text) {
    if (text.contains(',') || text.contains('"') || text.contains('\n')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }
  
  static double _calculateIncome(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type.name == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }
  
  static double _calculateExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type.name == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}

