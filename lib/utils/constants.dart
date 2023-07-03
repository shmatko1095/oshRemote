import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';

class Constants {
  static const serialNumberKey = "SN";
  static const secureCodeKey = "SC";
  static const minSerialNumberLength = 8;
  static const minSecureCodeLength = 8;
  static const formPadding =
      EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 16);

  static const listPadding =
      EdgeInsets.only(left: 10, right: 10, top: 32, bottom: 16);

  static const TextStyle actualTempStyle =
      TextStyle(fontSize: 110, fontWeight: FontWeight.w300);
  static const TextStyle actualTempUnitStyle =
      TextStyle(fontSize: 50, fontWeight: FontWeight.w300);
  static const TextStyle targetTempStyle = TextStyle(fontSize: 40);
  static const TextStyle targetUnitTempStyle = TextStyle(fontSize: 16);

  static const TextStyle calendarListStyle = TextStyle(fontSize: 30);

  static const arrowSizeInListMenu = 17.0;

  static const topicCommand = "command/";

  /// Topic to connect or disconnect thing
  static const topicConnect = "${topicCommand}connect";

  static const minWaterTempDif = 1;
  static const maxWaterTempDif = 20;

  static const minWaterTempValue = 20;
  static const maxWaterTempValue = 90;

  static const minChartWaterTempValue = 0;
  static const maxChartWaterTempValue = 50;

  static const minAirTempValue = 5.0;
  static const maxAirTempValue = 40.0;
  static const airTempStep = 0.5;

  static const maxChartAirTempValue = 30.0;

  static const minGridValue = 160;
  static const maxGridValue = 230;

  static const minChartGridValue = minGridValue;
  static const maxChartGridValue = 240;

  static const minPumpPwmValue = 10;
  static const maxPumpPwmValue = 100;

  static const minPumpSwitchedValue = 0;
  static const maxPumpSwitchedValue = 3;

  static const minPumpDelayValue = 5;
  static const maxPumpDelayValue = 60;

  static const minHeaterConfig = 1;
  static const minChartHeaterValue = 0;

  static const minChartPressureValue = 0;
  static const maxChartPressureValue = 3.0;

  static const Map<PumpConfig, double> pumpConfigMaxValue = {
    PumpConfig.constant: 1,
    PumpConfig.switched: 3,
    PumpConfig.pwm: 100,
  };
}
