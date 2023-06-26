import 'package:mqtt_client_repository/device_emulator/drivers/random_step.dart';

class TempSensor with DoubleRandomStep {
  double val;
  final double min;
  final double max;
  final double maxStep;

  TempSensor(
      {double this.val = 22,
      double this.maxStep = 1,
      double this.min = 0,
      required double this.max});

  double get() => getNext(val, maxStep, max, min);
}
