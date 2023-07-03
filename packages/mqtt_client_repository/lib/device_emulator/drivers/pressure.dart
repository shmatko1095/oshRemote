import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';
import 'package:mqtt_client_repository/device_emulator/utils/random_step.dart';

class Pressure with RandomStep implements Input {
  double val;
  double max;
  double maxStep;

  Pressure({this.val = 1.8, this.maxStep = 0.2, this.max = 4.0});

  @override
  double get() => RandomStep.getNextDouble(val, maxStep, max, 0);
}
