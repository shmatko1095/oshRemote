import 'package:mqtt_client_repository/device_emulator/app/charts/charts_app.dart';
import 'package:mqtt_client_repository/device_emulator/app/heater/heater_app.dart';
import 'package:mqtt_client_repository/device_emulator/app/heater/pump_app.dart';
import 'package:mqtt_client_repository/device_emulator/device_model.dart';
import 'package:mqtt_client_repository/mqtt_broker_mock/mqtt_broker_mock.dart';

import 'app/info_sender.dart';

class DeviceEmulator {
  late final DeviceModel model;

  /**App list*/
  late final HeaterApp _heaterApp;
  late final PumpApp _pumpApp;
  late final InfoSender _infoSender;
  late final ChartsApp _chartsApp;

  DeviceEmulator(MqttBrokerMock broker) : model = DeviceModel(broker) {
    _infoSender = InfoSender(
        mqttService: model.mqttService,
        heaterStatus: model.heater,
        pumpStatus: model.pump,
        tempIn: model.inTemp,
        tempOut: model.outTemp,
        pressure: model.pressure,
        powerUsage: model.powerUsage,
        airTempAct: model.airTemp);

    _heaterApp = HeaterApp(
      airTemp: model.airTemp,
      calendar: model.calendar,
      heater: model.heater,
    );

    _pumpApp = PumpApp(
      targetDiff: 10.0,
      tempLimit: 45.0,
      outTemp: model.outTemp,
      inTemp: model.inTemp,
      pump: model.pump,
    );

    _chartsApp = ChartsApp(model: model);
  }

  void init() {
    model.init();

    _infoSender.init();
    _chartsApp.init();

    _heaterApp.start();
    _pumpApp.start();
    _infoSender.start(period: 5000);
    _chartsApp.start(period: 5000);
  }

  void deInit() {
    model.deInit();

    _heaterApp.stop();
    _pumpApp.stop();
    _infoSender.stop();
    _chartsApp.stop();
  }
}
