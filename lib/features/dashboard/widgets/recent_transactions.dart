import 'package:flutter/material.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/empty_state.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecentTransactions({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyState(
        message: 'No recent transactions',
        subtitle: 'Your recent transactions will appear here',
        icon: Icons.receipt_long,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...transactions.map((transaction) => _buildTransactionItem(context, transaction)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/transactions');
                },
                child: const Text('View All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: transaction.type.name == 'income'
                ? Colors.green.shade100
                : Colors.red.shade100,
            child: Icon(
              transaction.type.name == 'income'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: transaction.type.name == 'income' ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '${transaction.category.emoji} ${transaction.category.name} • ${Formatters.formatDate(transaction.date)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type.name == 'income' ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              color: transaction.type.name == 'income' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}