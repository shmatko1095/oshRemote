import 'package:mqtt_client_repository/device_emulator/utils/random_step.dart';

class ChartsGenerator with RandomStep {
  static Map<String, int> createInt(
      val, maxStep, max, min, int points, int timeStep,
      {bool isRect = false}) {
    Map<String, int> res = {};
    int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    for (int cnt = 0; cnt < points; cnt++) {
      val = RandomStep.getNextInt(val, maxStep, max, min);
      if (isRect) res[(unixTime - 1).toString()] = val;
      res[unixTime.toString()] = val;
      unixTime -= timeStep;
    }
    return res;
  }

  static Map<String, double> createDouble(
      val, maxStep, max, min, int points, int timeStep,
      {bool isRect = false}) {
    Map<String, double> res = {};
    int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    for (int cnt = 0; cnt < points; cnt++) {
      val = RandomStep.getNextDouble(val, maxStep, max, min);
      if (isRect) res[(unixTime - 1).toString()] = val;
      res[unixTime.toString()] = val;
      unixTime -= timeStep;
    }
    return res;
  }
}
