import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_data.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_settings.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThingControllerCubit extends Cubit<ThingControllerState> {
  ThingControllerCubit(MqttClientRepository mqttRepository)
      : _mqttRepository = mqttRepository,
        super(ThingControllerState.empty()) {
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  static const lastConnectedPrefsKey = "last_connected_thing_prefs";
  static const keyPrefix = "ThingCubit_";
  static const connectDelaySec = 15;

  late final SharedPreferences _prefs;

  late String _clientId;
  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>> _stream;

  final MqttClientRepository _mqttRepository;
  final Map<String, Timer> _connectionTimer = {};

  final _exceptionStreamController = StreamController<Exception>.broadcast();

  Stream<Exception> get exceptionStream => _exceptionStreamController.stream;

  final _widgetsStreamController = StreamController<String>.broadcast();

  Stream<String> get widgetsStream => _widgetsStreamController.stream;

  @override
  Future<void> close() {
    _stream.cancel();
    _exceptionStreamController.close();
    _widgetsStreamController.close();
    return super.close();
  }

  Future<void> init({required String clientId}) async {
    _clientId = clientId;
    _stream = _mqttRepository.getMessagesStream()!.listen((event) {
      for (var element in event) {
        Future.microtask(() => _handleReceivedMsg(element));
      }
    });
  }

  void updateThingList({required List<String> snList}) {
    Map<String, ThingData> thingMap = {};
    for (var sn in snList) {
      String? name = _prefs.getString(sn);
      thingMap[sn] =
          ThingData(sn: sn, name: name, config: const ThingConfig.pure());
      _subscribeToThingTopics("$_clientId/$sn");
    }
    emit(state.updateMap(thingMap));
  }

  void _subscribeToThingTopics(String thingTopic) =>
      _mqttRepository.subscribe("$thingTopic/#", MqttQos.atLeastOnce);

  void connect({required String sn}) {
    try {
      _publishConnectStatus(sn, true);
      _setupConnectionTimer(sn);
      emit(state.copyWith(sn, status: ThingConnectionStatus.connecting));
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
  }

  void disconnect({required String sn}) {
    try {
      _publishConnectStatus(sn, false);
      emit(state.copyWith(sn, status: ThingConnectionStatus.disconnected));
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
  }

  void disconnectConnectedThings() {
    state.thingDataMap.values
        .where((data) => data.status != ThingConnectionStatus.disconnected)
        .forEach((data) => disconnect(sn: data.sn));
  }

  void _publishConnectStatus(String sn, bool status) {
    final builder = MqttClientPayloadBuilder();
    final data = {
      Constants.keyClientId: _clientId,
      Constants.keyStatus: status,
    };
    builder.addString(jsonEncode(data));
    final topic = "$sn/${Constants.topicConnect}";
    _mqttRepository.publish(topic, MqttQos.atLeastOnce, builder);
  }

  void pushSettings() {
    final builder = MqttClientPayloadBuilder();
    final data = state.connectedThing!.settings!.toJson();
    data[Constants.keyClientId] = _clientId;
    builder.addString(jsonEncode(data));

    String sn = state.connectedThing!.sn;
    final topic = "$sn/${Constants.topicSettingsSet}";
    _mqttRepository.publish(topic, MqttQos.atLeastOnce, builder);
  }

  void _setName(String sn, String name) {
    _prefs.setString(sn, name);
    emit(state.copyWith(sn, name: name));
  }

  void _resetName(String sn) {
    _prefs.remove(sn);
    emit(state.copyWith(sn, name: sn));
  }

  void rename({required String sn, String? name}) {
    name != null ? _setName(sn, name) : _resetName(sn);
  }

  void _handleReceivedMsg(MqttReceivedMessage<MqttMessage> message) {
    final msg = message.payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(msg.payload.message);
    final sn = _getSnFromTopic(message.topic);

    if (message.topic.endsWith(Constants.topicConnect)) {
      _handleConnect(payload);
    } else if (message.topic.endsWith(Constants.topicDataUpdate)) {
      _widgetsStreamController.add(payload);
    } else if (message.topic.endsWith(Constants.topicSettingsUpdate)) {
      _handleSettingsUpdate(sn, payload);
    }
  }

  String _getSnFromTopic(String topic) => topic.split('/')[1];

  void _handleConnect(String payload) {
    final data = jsonDecode(payload);
    final sn = data[Constants.keyClientId];
    final status = data[Constants.keyStatus];
    final config = ThingConfig.fromJson(data[Constants.keyConfig]);
    final settings = ThingSettings.fromJson(data[Constants.keySettings]);

    emit(state.copyWith(sn,
        config: config,
        settings: settings,
        status: status == true
            ? ThingConnectionStatus.connected
            : ThingConnectionStatus.disconnected));

    _saveLastConnectedThing(sn);
    _removeConnectionTimer(sn);
  }

  void _handleSettingsUpdate(String sn, String payload) {
    final data = jsonDecode(payload);
    final thingSettings = ThingSettings.fromJson(data);
    emit(state.copyWith(sn, settings: thingSettings));
  }

  void _saveLastConnectedThing(String sn) {
    _prefs.setString(lastConnectedPrefsKey, sn);
  }

  String? get lastConnectedThing {
    return _prefs.getString(lastConnectedPrefsKey);
  }

  void _removeConnectionTimer(String sn) {
    _connectionTimer[sn]?.cancel();
    _connectionTimer.remove(sn);
  }

  void _setupConnectionTimer(String sn) {
    _connectionTimer[sn] = Timer(const Duration(seconds: connectDelaySec), () {
      final data = state.getThingData(sn);
      if (data != null) {
        emit(state.copyWith(sn, status: ThingConnectionStatus.disconnected));
        _removeConnectionTimer(sn);
      }
    });
  }
}