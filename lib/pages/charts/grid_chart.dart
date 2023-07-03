// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:intl/intl.dart';
// import 'package:osh_remote/block/thing_cubit/model/charts/chart_data.dart';
// import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
// import 'package:osh_remote/utils/constants.dart';
//
// class MainsChart extends StatelessWidget {
//   MainsChart({super.key});
//
//   static const Color mainGridLineColor = Colors.white10;
//   static const Color contentColorBlue = Color(0xFF2196F3);
//   static const Color contentColorCyan = Color(0xFF50E4FF);
//
//   static const _chartTestStyle = TextStyle(
//     fontWeight: FontWeight.w200,
//     fontSize: 12,
//   );
//
//   final List<Color> gradientColors = [
//     const Color(0xFFFFA500),
//     const Color(0xFFFFC500),
//     const Color(0xFFFFDB00),
//     const Color(0xFFFFED00),
//   ];
//
//   ChartData _data(BuildContext context) =>
//       context.read<ThingControllerCubit>().state.charts!.mains!;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         child: Column(children: [
//       Text(S.of(context)!.mainsVoltage),
//       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//         Column(
//           children: [
//             Text(S.of(context)!.minimum),
//             Text("${_data(context).minV}"),
//           ],
//         ),
//         Column(
//           children: [
//             Text(S.of(context)!.maximum),
//             Text("${_data(context).maxV}"),
//           ],
//         )
//       ]),
//       AspectRatio(
//         aspectRatio: 1.70,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             right: 18,
//             left: 12,
//             top: 24,
//             bottom: 12,
//           ),
//           child: LineChart(mainData(context)),
//         ),
//       ),
//     ]));
//   }
//
//   AxisTitles _emptyTitle() =>
//       AxisTitles(sideTitles: SideTitles(showTitles: false));
//
//   AxisTitles _leftTitle() {
//     return AxisTitles(
//         sideTitles: SideTitles(
//       showTitles: true,
//       interval: 20,
//       getTitlesWidget: (value, meta) => Text("${value.toInt()}V",
//           style: _chartTestStyle, textAlign: TextAlign.left),
//       reservedSize: 42,
//     ));
//   }
//
//   List<FlSpot> _getFlSpotData(BuildContext context) {
//     return List.generate(_data(context).data.length, (index) {
//       return FlSpot(index.toDouble(),
//           _data(context).data.values.toList()[index].toDouble());
//     });
//   }
//
//   Widget getTitles(BuildContext context, double value, TitleMeta meta) {
//     bool isLast = value == _data(context).data.keys.length - 1;
//     bool isPreLast =
//         value + getTitlesInterval(context) > _data(context).data.keys.length;
//     if (!isLast && isPreLast) {
//       return const Text("");
//     } else {
//       return Text(
//           DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(
//               _data(context).data.keys.toList()[value.toInt()] * 1000)),
//           style: _chartTestStyle);
//     }
//   }
//
//   double getTitlesInterval(BuildContext context) {
//     return (((_data(context).data.values.length + 9) / 9) ~/ 1).toDouble();
//   }
//
//   List<LineTooltipItem> tooltipItem(
//       BuildContext context, List<LineBarSpot> touchedSpots) {
//     return touchedSpots.map((LineBarSpot touchedSpot) {
//       final textStyle = TextStyle(
//         color: touchedSpot.bar.gradient?.colors.first ??
//             touchedSpot.bar.color ??
//             Colors.blueGrey,
//         fontWeight: FontWeight.bold,
//         fontSize: 14,
//       );
//
//       String time = DateFormat('HH:mm').format(
//           DateTime.fromMillisecondsSinceEpoch(
//               _data(context).data.keys.toList()[touchedSpot.x.toInt()] * 1000));
//
//       return LineTooltipItem(
//           "${touchedSpot.y.toInt().toString()}V, $time", textStyle);
//     }).toList();
//   }
//
//   LineChartData mainData(BuildContext context) {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         drawHorizontalLine: false,
//         verticalInterval: getTitlesInterval(context),
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: _emptyTitle(),
//         topTitles: _emptyTitle(),
//         bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//           interval: getTitlesInterval(context),
//           getTitlesWidget: (value, meta) => getTitles(context, value, meta),
//         )),
//         leftTitles: _leftTitle(),
//       ),
//       borderData: FlBorderData(show: false),
//       minY: Constants.minChartGridValue.toDouble(),
//       maxY: Constants.maxChartGridValue.toDouble(),
//       lineTouchData: LineTouchData(
//         enabled: true,
//         touchTooltipData: LineTouchTooltipData(
//             getTooltipItems: (spots) => tooltipItem(context, spots)),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           spots: _getFlSpotData(context),
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 1,
//           isStrokeCapRound: true,
//           dotData: FlDotData(show: false),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.4))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
