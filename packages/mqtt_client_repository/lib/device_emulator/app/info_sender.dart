import 'dart:convert';

import 'package:mqtt_client_repository/device_emulator/app/i_runnable.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/heater.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/load_meter.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/pressure.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/pump.dart';
import 'package:mqtt_client_repository/device_emulator/drivers/temp_sensor.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/I_mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';

class InfoTopicCommands {
  static const set = "${PublicMqttTopics.info}/set";
  static const update = "${PublicMqttTopics.info}/update";
}

class InfoKey {
  static const heaterStatus = "hS";
  static const pumpStatus = "pS";
  static const tempIn = "tI";
  static const tempOut = "tO";
  static const pressure = "pr";
  static const powerUsage = "pU";
  static const airTempAct = "aTA";
}

class InfoSender extends Runnable implements IMqttClient {
  final IMqttService mqttService;

  final Heater heaterStatus;
  final Pump pumpStatus;
  final TempSensor tempIn;
  final TempSensor tempOut;
  final Pressure pressure;
  final LoadMeter powerUsage;
  final TempSensor airTempAct;

  InfoSender({
    required this.mqttService,
    required this.heaterStatus,
    required this.pumpStatus,
    required this.tempIn,
    required this.tempOut,
    required this.pressure,
    required this.powerUsage,
    required this.airTempAct,
  }) : super(period: 5000);

  Map<String, dynamic> _toJson() => {
        InfoKey.heaterStatus: heaterStatus.get(),
        InfoKey.pumpStatus: pumpStatus.get(),
        InfoKey.tempIn: tempIn.get(),
        InfoKey.tempOut: tempOut.get(),
        InfoKey.pressure: pressure.get(),
        InfoKey.powerUsage: powerUsage.get(),
        InfoKey.airTempAct: airTempAct.get()
      };

  void init() {
    mqttService.subscribe(PublicMqttTopics.connect, this);
  }

  @override
  Map<String, Map<String, dynamic>>? handle(String topic, String payload) {
    Map<String, Map<String, dynamic>> res = {};
    res[PublicMqttTopics.info] = _toJson();
    return res;
  }

  void run() {
    mqttService.publish(InfoTopicCommands.update, jsonEncode(_toJson()));
  }
}
