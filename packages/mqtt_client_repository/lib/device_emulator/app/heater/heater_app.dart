import 'package:mqtt_client_repository/device_emulator/app/calendar/calendar.dart';
import 'package:mqtt_client_repository/device_emulator/app/calendar/calendar_point.dart';
import 'package:mqtt_client_repository/device_emulator/app/i_runnable.dart';
import 'package:mqtt_client_repository/device_emulator/device_config.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/heater.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/temp_sensor.dart';

class HeaterApp extends Runnable {
  final TempSensor airTemp;
  final Calendar calendar;
  final Heater heater;

  HeaterApp({
    required this.airTemp,
    required this.calendar,
    required this.heater,
  });

  void run() {
    CalendarPoint point = calendar.current;
    point.value > airTemp.get()
        ? heater.set(point.power ?? DeviceConfig.heaterConfig)
        : heater.set(0);
  }
}
