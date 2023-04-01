import 'package:osh_remote/models/mqtt_message_header.dart';

class MqttMessageDescriptor {
  final String message;
  final MqttMessageHeader header;

  const MqttMessageDescriptor(this.message, this.header);
}
