import 'package:flutter/cupertino.dart';

class Constants {
  static const serialNumberKey = "SN";
  static const secureCodeKey = "SC";
  static const minSerialNumberLength = 8;
  static const minSecureCodeLength = 8;
  static const formPadding =
      EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 16);

  static const topicCommand = "command/";

  /// Command to connect or disconnect thing
  static const connectTopic = "${topicCommand}connect/";
  static const connectKeyClientId = "clientId";
  static const connectKeyStatus = "status";
}
