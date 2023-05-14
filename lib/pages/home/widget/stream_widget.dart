import 'dart:async';

abstract class StreamWidget {
  final StreamController<String> _streamController =
      StreamController<String>.broadcast();

  StreamSink<String> get sink => _streamController.sink;

  Stream<String> get stream => _streamController.stream;
}
