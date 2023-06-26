import 'package:mqtt_client_repository/device_emulator/drivers/random_step.dart';

class LoadMeter with DoubleRandomStep {
  int val;
  int max;
  int maxStep;

  LoadMeter({this.val = 0, this.maxStep = 100, this.max = 100});

  int get() => getNext(val, maxStep, max, 0).round();
}
