import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/empty_state.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_form.dart';

class TransactionList extends StatelessWidget {
  final int? itemCount;

  const TransactionList({Key? key, this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == TransactionsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.transactions.isEmpty) {
          return const EmptyState(
            message: 'No transactions yet',
            subtitle: 'Add your first transaction to get started',
          );
        }

        final transactions = itemCount != null
            ? state.transactions.take(itemCount!).toList()
            : state.transactions;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _TransactionListItem(transaction: transaction);
          },
        );
      },
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionListItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type.name == 'income';
    final bgColor = isIncome 
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFEF2F2);
    final iconBgColor = isIncome
        ? const Color(0xFF10B981).withOpacity(0.1)
        : const Color(0xFFEF4444).withOpacity(0.1);
    final iconColor = isIncome 
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          ),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Delete Transaction?"),
              content: const Text("This action cannot be undone."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TransactionsBloc>().add(
              DeleteTransaction(transaction.id),
            );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Transaction deleted'),
              ],
            ),
            backgroundColor: const Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: const Color(0xFF818CF8),
              onPressed: () {
                context.read<TransactionsBloc>().add(
                      AddTransaction(transaction),
                    );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: ListTile(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TransactionForm(transaction: transaction),
                );
              },
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Text(
            transaction.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  transaction.category.emoji,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  transaction.category.name,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatDate(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}