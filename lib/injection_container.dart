import 'package:get_it/get_it.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:mqtt_repository/mqtt_repository.dart';
import 'package:user_repository/user_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerSingleton<AuthenticationRepository>(AuthenticationRepository());
  getIt.registerSingleton<UserRepository>(UserRepository());
  // getIt.registerSingleton<MqttServerClientRepository>(MqttServerClientRepository());
}