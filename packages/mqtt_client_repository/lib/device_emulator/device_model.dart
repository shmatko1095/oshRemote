import 'package:mqtt_client_repository/device_emulator/app/calendar/calendar.dart';
import 'package:mqtt_client_repository/device_emulator/app/settings/settings.dart';
import 'package:mqtt_client_repository/device_emulator/device_config.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/heater.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/load_meter.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/pressure.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/pump.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/temp_sensor.dart';
import 'package:mqtt_client_repository/device_emulator/hw/gpio.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/mqtt_service.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';

class DeviceModel {
  final pump = PwmPump(GPIO<int>(name: "pumpOut"));
  final heater = Heater(GPIO<int>(name: "heaterOut"));
  final inTemp = TempSensor(max: 45);
  final outTemp = TempSensor(max: 45);
  final airTemp = TempSensor(min: -5, max: 45);
  final pressure = Pressure();
  final powerUsage = LoadMeter();

  late final Settings settings;
  late final Calendar calendar;
  late final DeviceConfig config;
  late final MqttService mqttService;

  DeviceModel(MqttBrokerMock broker) {
    mqttService = MqttService(broker: broker);
    calendar = Calendar(mqttService: mqttService);
    settings = Settings(mqttService: mqttService);
    config = DeviceConfig(mqttService: mqttService);
  }

  void init() {
    config.init();
    calendar.init();
    settings.init();
    mqttService.init();
  }

  void deInit() {
    mqttService.deInit();
  }
}
