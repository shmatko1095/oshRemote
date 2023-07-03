import 'dart:math';

mixin RandomStep {
  static round(val) => (val * 10).round() / 10;

  static double getNextDouble(val, maxStep, max, min) {
    do {
      final step = Random().nextDouble() * maxStep;
      val = Random().nextBool() ? val + step : val - step;
    } while (val > max || val < min);
    return round(val);
  }

  static int getNextInt(val, maxStep, max, min) {
    do {
      final step = Random().nextInt(maxStep + 1);
      val = Random().nextBool() ? val + step : val - step;
    } while (val > max || val < min);
    return val;
  }
}
