import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:osh_remote/block/thing_cubit/model/charts/chart_data.dart';

//разобратся с шагом слева

class Chart extends StatelessWidget {
  final String name;
  final double minY;
  final double maxY;
  final String units;
  final ChartData data;
  final List<Color> gradient;
  final bool isCurved;

  const Chart(
      {required this.name,
      required this.units,
      required this.data,
      required this.gradient,
      required this.minY,
      required this.maxY,
      this.isCurved = true,
      super.key});

  static const Color mainLineColor = Colors.white10;

  static const _nameTextStyle = TextStyle(fontSize: 20);
  static const _minMaxValTextStyle = TextStyle(fontSize: 18);
  static const _minMaxNameTextStyle = TextStyle(fontSize: 12);

  static const _chartTestStyle = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Text(name, style: _nameTextStyle),
      const Divider(),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Text(S.of(context)!.minimum, style: _minMaxNameTextStyle),
            Text("${data.minV}$units", style: _minMaxValTextStyle),
          ],
        ),
        Column(
          children: [
            Text(S.of(context)!.maximum, style: _minMaxNameTextStyle),
            Text("${data.maxV}$units", style: _minMaxValTextStyle),
          ],
        )
      ]),
      AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 24,
            bottom: 12,
          ),
          child: LineChart(mainData(context)),
        ),
      ),
    ]));
  }

  AxisTitles _emptyTitle() =>
      AxisTitles(sideTitles: SideTitles(showTitles: false));

  AxisTitles _bottomTitle() {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
      interval: _getTitlesInterval(),
      getTitlesWidget: (value, meta) => _getTitles(value, meta),
    ));
  }

  AxisTitles _leftTitle() {
    return AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      interval: 20,
      getTitlesWidget: (value, meta) => Text("${value.toInt()}$units",
          style: _chartTestStyle, textAlign: TextAlign.left),
      reservedSize: 42,
    ));
  }

  List<FlSpot> _getFlSpotData(BuildContext context) {
    return List.generate(data.data.length, (index) {
      return FlSpot(
          index.toDouble(), data.data.values.toList()[index].toDouble());
    });
  }

  Widget _getTitles(double value, TitleMeta meta) {
    bool isLast = value == data.data.keys.length - 1;
    bool isPreLast = value + _getTitlesInterval() > data.data.keys.length;
    if (!isLast && isPreLast) {
      return const Text("");
    } else {
      return Text(
          DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(
              data.data.keys.toList()[value.toInt()] * 1000)),
          style: _chartTestStyle);
    }
  }

  _getTitlesInterval() => (((data.data.values.length + 9) / 9) ~/ 1).toDouble();

  List<LineTooltipItem> tooltipItem(
      BuildContext context, List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.gradient?.colors.first ??
            touchedSpot.bar.color ??
            Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

      String time = DateFormat('HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              data.data.keys.toList()[touchedSpot.x.toInt()] * 1000));

      return LineTooltipItem(
          "${touchedSpot.y.toString()}$units, $time", textStyle);
    }).toList();
  }

  LineChartData mainData(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        verticalInterval: _getTitlesInterval(),
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: mainLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: _emptyTitle(),
        topTitles: _emptyTitle(),
        bottomTitles: _bottomTitle(),
        leftTitles: _leftTitle(),
      ),
      borderData: FlBorderData(show: false),
      minY: minY,
      maxY: maxY,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => tooltipItem(context, spots)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _getFlSpotData(context),
          isCurved: isCurved,
          gradient: LinearGradient(
            colors: gradient,
          ),
          barWidth: 1,
          isStrokeCapRound: false,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradient.map((color) => color.withOpacity(0.6)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
