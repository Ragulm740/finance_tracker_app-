import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  final Map<String, double> categorySpending;

  const SpendingChart({
    Key? key,
    required this.categorySpending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360.0,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _getSections(),
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _getIndicators(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
  final total = categorySpending.values.fold(0.0, (sum, value) => sum + value); // Changed to 0.0

  return categorySpending.entries.map((entry) {
    return PieChartSectionData(
      color: getCategoryColor(entry.key),
      radius: 100.0,
      title: entry.value > 0 ? '\$${entry.value.toStringAsFixed(2)}' : '',
      value: entry.value,
    );
  }).toList()..add(
    PieChartSectionData(
      color: Colors.transparent, // Make this section transparent
      radius: 100.0,
      title: '', // No title for zero sections
      value: total == 0 ? 1 : 0, // Ensure at least one section exists
    ),
  );
}


  List<Widget> _getIndicators() {
    return categorySpending.keys.map((category) {
      return _Indicator(
        color: getCategoryColor(category),
        text: category,
      );
    }).toList();
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.green;
      case 'Salary':
        return Colors.orange;
      case 'Bonus':
        return Colors.purple;
      case 'Interest':
        return Colors.yellow;
      default:
        return Colors.grey; // Default color
    }
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
