import 'package:osh_remote/block/thing_cubit/model/thing_config.dart';
import 'package:osh_remote/block/thing_cubit/model/thing_settings.dart';

enum ThingConnectionStatus { connecting, connected, disconnected }

class ThingData {
  final String _sn;
  final String? _name;
  late final ThingConfig _config;
  late final ThingSettings _settings;
  late final ThingConnectionStatus _status;

  String get sn => _sn;

  ThingConnectionStatus get status => _status;

  ThingConfig get config => _config;

  ThingSettings get settings => _settings;

  String get name => _name ?? _sn;

  ThingData(
      {required String sn,
      String? name,
      required ThingConfig config,
      required ThingSettings settings,
      ThingConnectionStatus status = ThingConnectionStatus.disconnected})
      : _sn = sn,
        _name = name,
        _config = config,
        _status = status,
        _settings = settings;

  ThingData copyWith(
      {String? name,
      ThingConfig? thingConfig,
      ThingSettings? thingSettings,
      ThingConnectionStatus? status}) {
    return ThingData(
      sn: _sn,
      name: name ?? _name,
      status: status ?? _status,
      config: thingConfig ?? _config,
      settings: thingSettings ?? _settings,
    );
  }
}
