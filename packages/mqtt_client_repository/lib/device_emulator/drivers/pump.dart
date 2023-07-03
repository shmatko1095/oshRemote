import 'package:mqtt_client_repository/device_emulator/drivers/i_input.dart';
import 'package:mqtt_client_repository/device_emulator/hw/gpio.dart';

abstract class Pump implements Input {
  void set(int val);

  @override
  int get();
}

class PwmPump implements Pump {
  GPIO<int> out;

  PwmPump(this.out);

  @override
  void set(int val) => out.set(val);

  @override
  int get() => out.get();
}
