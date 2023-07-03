import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';
import 'package:mqtt_client_repository/device_emulator/hw/gpio.dart';

class Heater implements Input {
  final GPIO<int> out;

  Heater(this.out);

  void set(int val) => out.set(val);

  @override
  int get() => out.get();
}
