import 'dart:math';

mixin DoubleRandomStep {
  round(val) => (val * 10).round() / 10;

  double getNext(val, maxStep, max, min) {
    do {
      final step = Random().nextDouble() * maxStep;
      val = Random().nextBool() ? val + step : val - step;
    } while (val > max || val < min);
    return round(val);
  }
}
