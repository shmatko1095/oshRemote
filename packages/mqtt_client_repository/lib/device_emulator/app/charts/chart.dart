import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';

class Chart {
  final Input source;
  final String key;

  final Map<String, dynamic> data = {};

  Chart(
      {required this.key,
      required this.source,
      Map<String, dynamic> initial = const {}}) {
    data.addAll(initial);
  }

  void run() {
    _removeOldPoint();
    _addNewPoint();
  }

  void _removeOldPoint() {
    data.remove(data.keys.last);
  }

  void _addNewPoint() {
    int unixTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    data[unixTime.toString()] = source.get();
  }
}
