import 'package:mqtt_client_repository/device_emulator/drivers/pump.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/temp_sensor.dart';

import '../i_runnable.dart';

class PumpApp extends Runnable {
  final double targetDiff;
  final double tempLimit;
  final TempSensor outTemp;
  final TempSensor inTemp;
  final Pump pump;

  PumpApp({
    required this.targetDiff,
    required this.tempLimit,
    required this.outTemp,
    required this.inTemp,
    required this.pump,
  });

  void run() => _regulatePumpPower();

  void _regulatePumpPower() {
    double pumpPower = 1;
    double tempDiff = outTemp.get() - inTemp.get();

    if (_isLimit) {
      pumpPower = 100;
    } else if (tempDiff <= targetDiff) {
      pumpPower = 0;
    } else {
      pumpPower = tempDiff * 0.5;
    }

    pump.set(pumpPower.round());
  }

  bool get _isLimit => outTemp.get() > tempLimit || inTemp.get() > tempLimit;
}
