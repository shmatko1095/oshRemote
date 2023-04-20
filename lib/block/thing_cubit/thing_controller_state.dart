enum ThingConnectionStatus { connecting, connected, disconnected }

class ThingData {
  final String _sn;
  final String? _name;
  late final ThingConnectionStatus status;

  get sn => _sn;

  get name => _name ?? _sn;

  ThingData({required String sn, String? name, ThingConnectionStatus? status})
      : _sn = sn,
        _name = name {
    this.status = status ?? ThingConnectionStatus.disconnected;
  }

  ThingData copyWith({String? name, ThingConnectionStatus? status}) {
    return ThingData(
      sn: _sn,
      name: name ?? _name,
      status: status ?? this.status,
    );
  }
}

class ThingControllerState {
  final List<ThingData> _thingsList;

  ThingControllerState(List<ThingData> list) : _thingsList = list;

  ThingControllerState.empty() : _thingsList = [];

  ThingControllerState updateInstance(List<ThingData> list) {
    return ThingControllerState(List.from(list));
  }

  List<ThingData> updateThing(ThingData data) {
    List<ThingData> newList = List.from(_thingsList.toList());
    final index = newList.indexWhere((element) => element.sn == data.sn);
    index < 0 ? newList.add(data) : newList[index] = data;
    return newList;
  }

  List<ThingData> getThingDataList() {
    return _thingsList.toList();
  }

  ThingData? getThingData(String sn) {
    final index = _thingsList.indexWhere((element) => element.sn == sn);
    return index < 0 ? null : _thingsList[index];
  }
}
