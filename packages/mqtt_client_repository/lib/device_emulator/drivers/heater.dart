import 'package:mqtt_client_repository/device_emulator/hw/gpio.dart';

class Heater {
  final GPIO<int> out;

  Heater(this.out);

  void set(int val) => out.set(val);

  int get() => out.get();
}
