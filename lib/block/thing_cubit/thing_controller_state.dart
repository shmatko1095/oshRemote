import 'package:osh_remote/block/thing_cubit/model/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_data.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_info.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_settings.dart';

class ThingControllerState {
  final Map<String, ThingData> _thingsMap;

  Map<String, ThingData> get thingDataMap => Map.from(_thingsMap);

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
      {String? name,
      ThingInfo? info,
      ThingConfig? config,
      ThingSettings? settings,
      ThingCalendar? calendar,
      ThingConnectionStatus? status}) {
    final updated = getThingData(sn)!.copyWith(
        name: name,
        info: info,
        thingConfig: config,
        thingSettings: settings,
        thingCalendar: calendar,
        status: status);
    return addThing(updated);
  }

  ThingControllerState removeThing(String sn) {
    _thingsMap.remove(sn);
    return ThingControllerState(Map.from(_thingsMap));
  }

  ThingData? getThingData(String sn) => _thingsMap[sn];

  ThingData? get connectedThing {
    bool test(ThingData data) => data.status == ThingConnectionStatus.connected;
    return thingDataMap.values.any(test)
        ? thingDataMap.values.firstWhere(
            (element) => element.status == ThingConnectionStatus.connected)
        : null;
  }

  ThingInfo? get info => connectedThing?.info;

  ThingConfig? get config => connectedThing?.config;

  ThingSettings? get settings => connectedThing?.settings;

  ThingCalendar? get calendar => connectedThing?.calendar;

  String? get sn => connectedThing?.sn;
}
