import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';
import 'package:mqtt_client_repository/device_emulator/utils/random_step.dart';

class TempSensor with RandomStep implements Input {
  double val;
  final double min;
  final double max;
  final double maxStep;

  TempSensor(
      {double this.val = 22,
      double this.maxStep = 1,
      double this.min = 0,
      required double this.max});

  @override
  double get() => RandomStep.getNextDouble(val, maxStep, max, min);
}
