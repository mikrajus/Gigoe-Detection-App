import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatefulWidget {
  const CustomChart({super.key, required this.result});

  final Map<String, double> result;

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  int touchedIndex = -1;

  final Duration animDuration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: BarChart(
        mainBarData(widget.result),
        swapAnimationDuration: animDuration,
      ),
    );
  }

  BarChartData mainBarData(Map<String, double> result) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        handleBuiltInTouches: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 2,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.toY.toInt().toString(),
              const TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 15,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(result),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String title;
    final titleInt = value.toInt();
    if (titleInt >= titleList.length) {
      title = '';
    } else {
      title = titleList[titleInt];
    }
    Widget text = Text(title, style: style);

    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups(Map<String, double> result) {
    final List<double?> values = result.values.toList();

    return List.generate(values.length, (i) {
      final value = values[i] != null ? values[i]!.toStringAsFixed(0) : '0';

      return makeGroupData(
        i,
        double.parse(value),
        showTooltips: [0],
      );
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    Color? barColor,
    double width = 24,
    List<int> showTooltips = const [],
  }) {
    barColor ??= AppColors.primaryBlue;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 30,
            color: AppColors.softBlue,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

final List<String> titleList = [
  'BN',
  'KA',
  'MX',
  'SK',
  'LB',
  'KR',
  'BR',
  'JB',
  'UK',
];

final List<String> namePlaceList = [
  'Baiturrahman',
  'Kuta Alam',
  'Meuraxa',
  'Syiah Kuala',
  'Lueng Bata',
  'Kuta Raja',
  'Banda Raya',
  'Jaya Baru',
  'Ulee Kareng',
];
