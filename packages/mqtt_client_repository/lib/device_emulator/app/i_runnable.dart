import 'dart:async';

abstract class Runnable {
  int period = 100;
  late Timer _timer;

  Runnable({this.period = 100});

  void run();

  void start() {
    _timer = Timer.periodic(Duration(milliseconds: period), (_) => run());
  }

  void stop() {
    _timer.cancel();
  }
}
