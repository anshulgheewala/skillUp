import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> logs;

  WeeklyBarChart({required this.logs});

  List<BarChartGroupData> _buildBarGroups() {
    final now = DateTime.now();
    Map<String, int> dailyTotals = {};

    // Initialize totals for last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      dailyTotals[dateStr] = 0;
    }

    // Accumulate hours per day
    for (var log in logs) {
      if (dailyTotals.containsKey(log['date'])) {
        dailyTotals[log['date']] = dailyTotals[log['date']]! + (log['hours'] as int);
      }
    }

    int i = 0;
    return dailyTotals.entries.map((entry) {
      return BarChartGroupData(
        x: i++,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blueAccent,
            width: 18,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  List<String> _buildWeekdayLabels() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return DateFormat.E().format(day); // E = Mon, Tue, etc.
    });
  }

  @override
  Widget build(BuildContext context) {
    final barGroups = _buildBarGroups();
    final labels = _buildWeekdayLabels();

    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < labels.length) {
                        return Text(labels[index], style: TextStyle(fontSize: 10));
                      }
                      return Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
              gridData: FlGridData(show: true),
            ),
          ),
        ),
      ),
    );
  }
}
