import 'package:mqtt_client_repository/device_emulator/hw/gpio.dart';

class DOGroup implements GPIO<int> {
  final String name;
  late int _val;

  DOGroup(this.name);

  void set(int val) {
    _val = val;
  }

  int get() => _val;
}
