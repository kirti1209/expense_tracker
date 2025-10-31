import 'package:flutter/material.dart';
import '../../../core/constants/category_constants.dart';
import '../../../core/models/budget_model.dart';
import '../../../core/utils/formatters.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final double utilization;
  final Function() onEdit;
  final Function() onDelete;

  const BudgetCard({
    Key? key,
    required this.budget,
    required this.utilization,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverBudget = utilization > 1.0;
    final progressColor = isOverBudget ? Colors.red : Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(budget.category.emoji),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    budget.category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${Formatters.formatCurrency(budget.monthlyLimit)} monthly limit',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: utilization > 1.0 ? 1.0 : utilization,
              backgroundColor: Colors.grey[300],
              color: progressColor,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatters.formatPercentage(utilization),
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOverBudget ? 'Over Budget!' : 'On Track',
                  style: TextStyle(
                    color: isOverBudget ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}