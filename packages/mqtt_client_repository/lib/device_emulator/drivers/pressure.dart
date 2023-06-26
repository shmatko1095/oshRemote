import 'package:mqtt_client_repository/device_emulator/drivers/random_step.dart';

class Pressure with DoubleRandomStep {
  double val;
  double max;
  double maxStep;

  Pressure({this.val = 1.8, this.maxStep = 0.2, this.max = 4.0});

  double get() => getNext(val, maxStep, max, 0);
}
