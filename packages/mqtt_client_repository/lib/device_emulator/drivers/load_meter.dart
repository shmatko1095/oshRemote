import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';
import 'package:mqtt_client_repository/device_emulator/utils/random_step.dart';

class LoadMeter with RandomStep implements Input {
  int val;
  int max;
  int maxStep;

  LoadMeter({this.val = 0, this.maxStep = 100, this.max = 100});

  @override
  int get() => RandomStep.getNextInt(val, maxStep, max, 0);
}
