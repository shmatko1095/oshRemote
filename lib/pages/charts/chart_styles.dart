import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/thing_cubit/model/charts/thing_charts.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/utils/constants.dart';

class ChartStyles {
  static const Map<ThingChartsKey, List<Color>> colors = {
    ThingChartsKey.heater: [
      Color(0xFFFF7300),
      Color(0xFFFFA500),
    ],
    ThingChartsKey.inTemp: [
      Color(0xFF2196F3),
      Color(0xFF50E4FF),
    ],
    ThingChartsKey.outTemp: [
      Color(0xFFF46B45),
      Color(0xFFEEA849),
    ],
    ThingChartsKey.pump: [
      Color(0xFF00B4DB),
      Color(0xFF0083B0),
    ],
    ThingChartsKey.powerUsage: [
      Color(0xFFE53935),
      Color(0xFFE35D5B),
    ],
    ThingChartsKey.pressure: [
      Color(0xff005c97),
      Color(0xff0068a1),
    ],
    ThingChartsKey.temp: [
      Color(0xff43bf43),
      Color(0xff1c7703),
    ],
    ThingChartsKey.grid: [
      Color(0xFFFFA500),
      Color(0xFFFFC500),
      Color(0xFFFFDB00),
      Color(0xFFFFED00)
    ]
  };

  // static const Map<ThingChartsKey, List<Color>> colors = {
  //   ThingChartsKey.heater: [
  //     Color(0xFFFFA500),
  //     Color(0xFFFFC500),
  //     Color(0xFFFFDB00),
  //     Color(0xFFFFED00)
  //   ],
  //   ThingChartsKey.inTemp: [
  //     Color(0xFF2196F3),
  //     Color(0xFF50E4FF),
  //   ],
  //   ThingChartsKey.outTemp: [
  //     Color(0xFFF46B45),
  //     Color(0xFFEEA849),
  //   ],
  //   // ThingChartsKey.pump: [
  //   //   Color(0xFF00C9FF),
  //   //   Color(0xFF92FE9D),
  //   // ],
  //   ThingChartsKey.pump: [
  //     Color(0xFF673AB7),
  //     Color(0xff512da8),
  //   ],
  //   ThingChartsKey.powerUsage: [
  //     Color(0xFFE53935),
  //     Color(0xFFE35D5B),
  //   ],
  //   ThingChartsKey.pressure: [
  //     Color(0xff005c97),
  //     Color(0xFF363795),
  //   ],
  //   ThingChartsKey.temp: [
  //     Color(0xffeacda3),
  //     Color(0xffd6ae7b),
  //   ],
  //   ThingChartsKey.grid: [
  //     Color(0xff334d50),
  //     Color(0xFFCBCAA5),
  //   ]
  // };

  static List<Color> getGradientByKey(ThingChartsKey key) {
    return colors[key] ?? [Colors.white, Colors.white10];
  }

  static double getMinByKey(ThingChartsKey key, double minFromChart) {
    switch (key) {
      case ThingChartsKey.heater:
        return Constants.minChartHeaterValue.toDouble();
      case ThingChartsKey.pump:
        return 0;
      case ThingChartsKey.temp:
        return min(0, minFromChart);
      case ThingChartsKey.grid:
        return min(Constants.minChartGridValue.toDouble(), minFromChart);
      case ThingChartsKey.inTemp:
      case ThingChartsKey.outTemp:
        return min(Constants.minChartWaterTempValue.toDouble(), minFromChart);
      case ThingChartsKey.pressure:
        return min(Constants.minChartPressureValue.toDouble(), minFromChart);
      case ThingChartsKey.powerUsage:
        return 0.toDouble();
    }
  }

  static double getMaxByKey(
      ThingChartsKey key, ThingConfig? config, double maxFromChart) {
    switch (key) {
      case ThingChartsKey.heater:
        return (config?.heaterConfig ?? Constants.minHeaterConfig).toDouble();
      case ThingChartsKey.pump:
        return Constants
            .pumpConfigMaxValue[config?.pumpConfig ?? PumpConfig.constant]!;
      case ThingChartsKey.temp:
        return max(Constants.maxChartAirTempValue, maxFromChart);
      case ThingChartsKey.grid:
        return max(Constants.maxChartGridValue.toDouble(), maxFromChart);
      case ThingChartsKey.inTemp:
      case ThingChartsKey.outTemp:
        return max(Constants.maxChartWaterTempValue.toDouble(), maxFromChart);
      case ThingChartsKey.pressure:
        return max(Constants.maxChartPressureValue.toDouble(), maxFromChart);
      case ThingChartsKey.powerUsage:
        return 100.toDouble();
    }
  }

  static String getNameByKey(ThingChartsKey key, BuildContext context) {
    switch (key) {
      case ThingChartsKey.heater:
        return S.of(context)!.heater_status;
      case ThingChartsKey.pump:
        return S.of(context)!.pump_status;
      case ThingChartsKey.temp:
        return S.of(context)!.temp;
      case ThingChartsKey.grid:
        return S.of(context)!.mains;
      case ThingChartsKey.inTemp:
        return S.of(context)!.temp_in;
      case ThingChartsKey.outTemp:
        return S.of(context)!.temp_out;
      case ThingChartsKey.pressure:
        return S.of(context)!.pressure;
      case ThingChartsKey.powerUsage:
        return S.of(context)!.power_usage;
    }
  }

  static bool getCurvedByKey(ThingChartsKey key) {
    return key == ThingChartsKey.heater ? false : true;
  }

  static String getUnitsByKey(ThingChartsKey key, ThingConfig? config) {
    switch (key) {
      case ThingChartsKey.heater:
        return "/${config?.heaterConfig.toString() ?? "-"}";
      case ThingChartsKey.pump:
        return "%";
      case ThingChartsKey.grid:
        return "V";
      case ThingChartsKey.temp:
      case ThingChartsKey.inTemp:
      case ThingChartsKey.outTemp:
        return "°C";
      case ThingChartsKey.pressure:
        return "bar";
      case ThingChartsKey.powerUsage:
        return "%";
    }
  }
}
