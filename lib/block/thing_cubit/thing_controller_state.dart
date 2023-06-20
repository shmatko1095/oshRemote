import 'package:osh_remote/block/thing_cubit/model/calendar/thing_calendar.dart';
import 'package:osh_remote/block/thing_cubit/model/charts/thing_charts.dart';
import 'package:osh_remote/block/thing_cubit/model/settings/thing_settings.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_data.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_info.dart';

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
      ThingCharts? charts,
      ThingConfig? config,
      ThingSettings? settings,
      ThingCalendar? calendar,
      ThingConnectionStatus? status}) {
    ThingData? data = getThingData(sn);
    if (data != null) {
      final updated = data.copyWith(
          name: name,
          info: info,
          thingCharts: charts,
          thingConfig: config,
          thingSettings: settings,
          thingCalendar: calendar,
          status: status);
      return addThing(updated);
    } else {
      return this;
    }
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

  ThingCharts? get charts => connectedThing?.charts;

  ThingConfig? get config => connectedThing?.config;

  ThingSettings? get settings => connectedThing?.settings;

  ThingCalendar? get calendar => connectedThing?.calendar;

  String? get sn => connectedThing?.sn;
}
