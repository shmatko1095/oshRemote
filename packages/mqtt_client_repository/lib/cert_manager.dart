import 'dart:async';

import 'package:flutter/services.dart';

class CertificateManager {
  static final String _ROOT_CA_PATH =
      "packages/mqtt_client_repository/assets/certs/AmazonRootCA1.pem";

  static ByteData? _rootCA;

  static Future<ByteData> getRootCertificate() async {
    _rootCA = _rootCA ?? await rootBundle.load(_ROOT_CA_PATH);
    return _rootCA!;
  }
}
