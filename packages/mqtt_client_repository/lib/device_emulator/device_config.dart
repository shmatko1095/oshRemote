import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/I_mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';

class DeviceConfig implements IMqttClient {
  static final int pumpConfig = 2;
  static final int heaterConfig = 6;
  static final int swVerMajor = 1;
  static final int swVerMinor = 1;
  static final int hwVerMajor = 1;
  static final int hwVerMinor = 1;

  final IMqttService _mqttService;

  DeviceConfig({required IMqttService mqttService})
      : _mqttService = mqttService;

  Map<String, dynamic> _toJson() => {
        ConfigKey.pumpConfig: pumpConfig,
        ConfigKey.heaterConfig: heaterConfig,
        ConfigKey.hwVerMajor: hwVerMajor,
        ConfigKey.hwVerMinor: hwVerMinor,
        ConfigKey.swVerMajor: swVerMajor,
        ConfigKey.swVerMinor: swVerMinor,
      };

  void init() {
    _mqttService.subscribe(PublicMqttTopics.connect, this);
  }

  @override
  Map<String, Map<String, dynamic>>? handle(String topic, String payload) {
    Map<String, Map<String, dynamic>> res = {};
    res[PublicMqttTopics.config] = _toJson();
    return res;
  }
}
