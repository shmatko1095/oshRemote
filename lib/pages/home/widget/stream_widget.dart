import 'dart:async';

// Should be changed to ValueListenableBuilder ValueNotifier
abstract class StreamWidget {
  final StreamController<String> _counterController =
      StreamController<String>();

  StreamSink<String> get counterSink => _counterController.sink;

  Stream<String> get counterStream => _counterController.stream;
}
