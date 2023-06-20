import 'package:mqtt_client_repository/device_emulator/device_emulator.dart';
import 'package:mqtt_client_repository/i_mqtt_client_repository.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:mqtt_client_repository/mqtt_client_repository_demo.dart';

import 'mqtt_broker_mock/mqtt_broker_mock.dart';

class MqttRepositoryFactory {
  static IMqttClientRepository? _instance;

  static IMqttClientRepository createInstance(
      {String? server, bool demo = false}) {
    if (demo) {
      final brokerMock = MqttBrokerMock();
      final demoDevice = DeviceEmulator(brokerMock);
      demoDevice.init();
      _instance = MqttClientRepositoryDemo(brokerMock);
    } else {
      _instance = MqttClientRepository(server!);
    }
    return _instance!;
  }

  static IMqttClientRepository getInstance() {
    if (_instance == null) {
      throw StateError("MqttClientRepository instance does not exists");
    }
    return _instance!;
  }
}
