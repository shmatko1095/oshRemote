import 'package:aws_iot_api/iot-2015-05-28.dart';
import 'package:aws_iot_repository/aws_iot_repository.dart';
import 'package:aws_iot_repository/aws_iot_repository_demo.dart';
import 'package:aws_iot_repository/i_aws_iot_repository.dart';

class AwsIotRepositoryFactory {
  static IAwsIotRepository? _instance;

  static IAwsIotRepository createInstance(
      {String? region, AwsClientCredentials? credentials, bool demo = false}) {
    _instance =
        demo ? AwsIotRepositoryDemo() : AwsIotRepository(region!, credentials!);
    return _instance!;
  }

  static IAwsIotRepository getInstance() {
    if (_instance == null) {
      throw StateError("AwsIotRepository instance does not exists");
    }
    return _instance!;
  }
}
