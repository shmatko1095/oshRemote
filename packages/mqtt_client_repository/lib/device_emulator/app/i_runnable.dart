import 'dart:async';

mixin Runnable {
  late Timer _timer;

  void run();

  void start({int period = 100}) {
    _timer = Timer.periodic(Duration(milliseconds: period), (_) => run());
  }

  void stop() {
    _timer.cancel();
  }
}
