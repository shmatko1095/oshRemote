import 'dart:convert';

import 'package:mqtt_client_repository/device_emulator/app/charts/chart.dart';
import 'package:mqtt_client_repository/device_emulator/app/charts/initial_data.dart';
import 'package:mqtt_client_repository/device_emulator/app/i_runnable.dart';
import 'package:mqtt_client_repository/device_emulator/constants.dart';
import 'package:mqtt_client_repository/device_emulator/device_config.dart';
import 'package:mqtt_client_repository/device_emulator/device_model.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/I_mqtt_client.dart';
import 'package:mqtt_client_repository/device_emulator/mqtt/i_mqtt_service.dart';

class ChartsTopicCommands {
  static const update = "${PublicMqttTopics.charts}/update";
}

class ChartsKey {
  static const charts = "charts";
  static const heater = "heater";
  static const pump = "pump";
  static const temp = "temp";
  static const grid = "grid";
  static const inTemp = "inTemp";
  static const outTemp = "outTemp";
  static const pressure = "pressure";
  static const powerUsage = "powerUsage";
}

class ChartsApp with Runnable implements IMqttClient {
  static const int timeStep = 60 * 15; //sec
  static const int pointsPerDay = 24 * 60 * 60 ~/ timeStep;

  final IMqttService mqttService;
  final DeviceModel model;

  final List<Chart> chartsList = [];

  ChartsApp({required this.model}) : mqttService = model.mqttService {
    chartsList.add(Chart(
        key: ChartsKey.heater,
        source: model.heater,
        initial: ChartsGenerator.createInt(
            3, 1, DeviceConfig.heaterConfig, 0, pointsPerDay, timeStep,
            isRect: true)));

    chartsList.add(Chart(
        key: ChartsKey.pump,
        source: model.pump,
        initial: ChartsGenerator.createInt(
            25, 25, 100, 0, pointsPerDay, timeStep,
            isRect: true)));

    chartsList.add(Chart(
        key: ChartsKey.temp,
        source: model.airTemp,
        initial: ChartsGenerator.createDouble(20, model.airTemp.maxStep,
            model.airTemp.max, model.airTemp.min, pointsPerDay, timeStep)));

    chartsList.add(Chart(
        key: ChartsKey.inTemp,
        source: model.inTemp,
        initial: ChartsGenerator.createDouble(
            model.inTemp.val,
            model.inTemp.maxStep,
            model.inTemp.max,
            model.inTemp.min,
            pointsPerDay,
            timeStep)));

    chartsList.add(Chart(
        key: ChartsKey.outTemp,
        source: model.outTemp,
        initial: ChartsGenerator.createDouble(
            model.outTemp.val,
            model.outTemp.maxStep,
            model.outTemp.max,
            model.outTemp.min,
            pointsPerDay,
            timeStep)));

    chartsList.add(Chart(
        key: ChartsKey.pressure,
        source: model.pressure,
        initial: ChartsGenerator.createDouble(
            model.pressure.val,
            model.pressure.maxStep,
            model.pressure.max,
            0,
            pointsPerDay,
            timeStep)));

    chartsList.add(Chart(
        key: ChartsKey.powerUsage,
        source: model.powerUsage,
        initial: ChartsGenerator.createInt(
            model.powerUsage.val,
            model.powerUsage.maxStep,
            model.powerUsage.max,
            0,
            pointsPerDay,
            timeStep)));
  }

  Map<String, dynamic>? _toJson() {
    Map<String, dynamic> res = {};
    chartsList.forEach((element) {
      res[element.key] = element.data;
    });
    return {ChartsKey.charts: res};
  }

  void init() {
    mqttService.subscribe(PublicMqttTopics.connect, this);
  }

  @override
  Map<String, dynamic>? handle(String topic, String payload) => _toJson();

  void run() {
    chartsList.forEach((element) => element.run());
    mqttService.publish(ChartsTopicCommands.update, jsonEncode(_toJson()));
  }
}
