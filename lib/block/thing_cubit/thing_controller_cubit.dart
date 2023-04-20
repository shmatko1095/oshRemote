import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client_repository/mqtt_client_repository.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThingControllerCubit extends Cubit<ThingControllerState> {
  ThingControllerCubit(MqttClientRepository mqttRepository)
      : _mqttRepository = mqttRepository,
        super(ThingControllerState.empty()) {
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  static const keyPrefix = "ThingCubit_";
  static const connectDelaySec = 5;

  late final SharedPreferences _prefs;

  late String _clientId;
  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>> _stream;

  final MqttClientRepository _mqttRepository;
  final Map<String, Timer> _connectionTimer = {};
  final _exceptionStreamController = StreamController<Exception>.broadcast();

  Stream<Exception> get exceptionStream => _exceptionStreamController.stream;

  @override
  Future<void> close() {
    _stream.cancel();
    _exceptionStreamController.close();
    return super.close();
  }

  Future<void> init({required String clientId}) async {
    _clientId = clientId;
    _stream = _mqttRepository.getMessagesStream()!.listen((event) {
      for (var element in event) {
        _handleReceivedMsg(element);
      }
    });
  }

  void updateThingList({required List<String> snList}) {
    List<ThingData> thingList = [];
    for (var sn in snList) {
      String? name = _prefs.getString(sn);
      thingList.add(ThingData(sn: sn, name: name));
      _subscribeToThingTopics("$_clientId/$sn");
    }

    emit(state.updateInstance(thingList));
  }

  void _subscribeToThingTopics(String thingTopic) =>
      _mqttRepository.subscribe("$thingTopic/#", MqttQos.atLeastOnce);

  void connect({required String sn}) {
    try {
      _publishConnectStatus(sn, true);
      final updated = state
          .getThingData(sn)!
          .copyWith(status: ThingConnectionStatus.connecting);
      _setupConnectionTimer(sn);
      emit(state.updateInstance(state.updateThing(updated)));
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
  }

  void disconnect({required String sn}) {
    try {
      _publishConnectStatus(sn, false);
      final updated = state
          .getThingData(sn)!
          .copyWith(status: ThingConnectionStatus.disconnected);
      emit(state.updateInstance(state.updateThing(updated)));
    } on Exception catch (e) {
      _exceptionStreamController.add(e);
    }
  }

  void disconnectConnectedThings() {
    state
        .getThingDataList()
        .where((data) => data.status != ThingConnectionStatus.disconnected)
        .forEach((data) => disconnect(sn: data.sn));
  }

  void _publishConnectStatus(String sn, bool status) {
    final builder = MqttClientPayloadBuilder();
    final data = {
      Constants.connectKeyClientId: _clientId,
      Constants.connectKeyStatus: status,
    };
    builder.addString(jsonEncode(data));
    final topic = "$sn/${Constants.connectTopic}";
    _mqttRepository.publish(topic, MqttQos.atLeastOnce, builder);
  }

  void _setName(String sn, String name) {
    final updated = state.getThingData(sn)!.copyWith(name: name);
    _prefs.setString(sn, name);
    emit(state.updateInstance(state.updateThing(updated)));
  }

  void _resetName(String sn) {
    final updated = state.getThingData(sn)!.copyWith(name: sn);
    _prefs.remove(sn);
    emit(state.updateInstance(state.updateThing(updated)));
  }

  void rename({required String sn, String? name}) {
    name != null ? _setName(sn, name) : _resetName(sn);
  }

  void _handleReceivedMsg(MqttReceivedMessage<MqttMessage> message) {
    final msg = message.payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(msg.payload.message);

    if (message.topic.endsWith(Constants.connectTopic)) {
      _handleConnect(payload);
    }
  }

  void _handleConnect(String payload) {
    final data = jsonDecode(payload);
    final sn = data[Constants.connectKeyClientId];
    final status = data[Constants.connectKeyStatus];
    final thingData = state.getThingData(sn);
    final newList = state.updateThing(thingData!.copyWith(
        status: status == true
            ? ThingConnectionStatus.connected
            : ThingConnectionStatus.disconnected));
    emit(state.updateInstance(newList));
    _removeConnectionTimer(sn);
  }

  void _removeConnectionTimer(String sn) {
    _connectionTimer[sn]?.cancel();
    _connectionTimer.remove(sn);
  }

  void _setupConnectionTimer(String sn) {
    _connectionTimer[sn] = Timer(const Duration(seconds: connectDelaySec), () {
      final data = state.getThingData(sn);
      if (data != null) {
        final val = data.copyWith(status: ThingConnectionStatus.disconnected);
        emit(state.updateInstance(state.updateThing(val)));
        _removeConnectionTimer(sn);
      }
    });
  }
}
