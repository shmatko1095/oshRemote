import 'package:osh_remote/block/thing_cubit/thing_config.dart';

enum ThingConnectionStatus { connecting, connected, disconnected }

class ThingData {
  final String _sn;
  final String? _name;
  final ThingConfig? _thingConfig;
  late final ThingConnectionStatus _status;

  get sn => _sn;

  get status => _status;

  get name => _name ?? _sn;

  ThingData(
      {required String sn,
      String? name,
      ThingConfig? thingConfig,
      ThingConnectionStatus? status})
      : _sn = sn,
        _name = name,
        _thingConfig = thingConfig,
        _status = status ?? ThingConnectionStatus.disconnected;

  ThingData copyWith(
      {String? name, ThingConfig? thingConfig, ThingConnectionStatus? status}) {
    return ThingData(
      sn: _sn,
      name: name ?? _name,
      status: status ?? _status,
      thingConfig: thingConfig ?? _thingConfig,
    );
  }
}

class ThingControllerState {
  final Map<String, ThingData> _thingsMap;

  ThingControllerState(Map<String, ThingData> map) : _thingsMap = map;

  ThingControllerState.empty() : _thingsMap = {};

  ThingControllerState updateMap(Map<String, ThingData> map) {
    return ThingControllerState(Map.from(map));
  }

  ThingControllerState addThing(ThingData thingData) {
    final map = thingDataMap;
    map[thingData.sn] = thingData;
    return ThingControllerState(map);
  }

  ThingControllerState copyWith(String sn,
      {String? name, ThingConfig? config, ThingConnectionStatus? status}) {
    final updated = getThingData(sn)!
        .copyWith(name: name, thingConfig: config, status: status);
    return addThing(updated);
  }

  ThingControllerState removeThing(String sn) {
    _thingsMap.remove(sn);
    return ThingControllerState(Map.from(_thingsMap));
  }

  ThingData? getThingData(String sn) => _thingsMap[sn];

  Map<String, ThingData> get thingDataMap => Map.from(_thingsMap);

  ThingData? get connectedThing {
    bool test(ThingData data) => data.status == ThingConnectionStatus.connected;
    return thingDataMap.values.any(test)
        ? thingDataMap.values.firstWhere((element) =>
    element.status == ThingConnectionStatus.connected)
        : null;
  }
}
