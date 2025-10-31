import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/category_constants.dart';
import '../../../core/utils/formatters.dart';

class ExpenseChart extends StatelessWidget {
  final Map<dynamic, double> expensesByCategory;

  const ExpenseChart({
    Key? key,
    required this.expensesByCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalExpenses = expensesByCategory.values.fold(0.0, (sum, amount) => sum + amount);
    
    if (totalExpenses == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Expense Distribution',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'No expenses yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final chartData = _prepareChartData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: chartData,
                        centerSpaceRadius: 30,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildLegend(chartData),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _prepareChartData() {
    // Colors that work well in both light and dark themes
    final List<Color> colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFEC4899), // Pink
    ];

    int colorIndex = 0;
    final List<PieChartSectionData> sections = [];

    for (final category in Category.all) {
      final amount = expensesByCategory[category] ?? 0.0;
      if (amount > 0) {
        final percentage = (amount / expensesByCategory.values.fold(0.0, (sum, value) => sum + value)) * 100;
        
        sections.add(
          PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: amount,
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        colorIndex++;
      }
    }

    return sections;
  }

  Widget _buildLegend(List<PieChartSectionData> sections) {
    // Colors that work well in both light and dark themes
    final List<Color> colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
      const Color(0xFFEC4899), // Pink
    ];

    int colorIndex = 0;
    final List<Widget> legendItems = [];

    for (final category in Category.all) {
      final amount = expensesByCategory[category] ?? 0.0;
      if (amount > 0) {
        legendItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: colors[colorIndex % colors.length],
                ),
                const SizedBox(width: 8),
                Text('${category.emoji} ${category.name}'),
                const Spacer(),
                Text(
                  Formatters.formatCurrency(amount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        colorIndex++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendItems,
    );
  }
}