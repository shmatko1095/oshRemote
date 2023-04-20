import 'package:shared_preferences/shared_preferences.dart';

class KeyPair {
  final String privateKey;
  final String publicKey;

  const KeyPair({required this.privateKey, required this.publicKey});
}

class Certificate {
  final String arn;
  final String id;
  final String pem;
  final KeyPair pair;

  const Certificate(
      {required this.arn,
      required this.id,
      required this.pem,
      required this.pair});
}

class CertificateProvider {
  static const _certificateArnKey = "certificateArn";
  static const _certificateIdKey = "certificateId";
  static const _certificatePemKey = "certificatePem";
  static const _certificatePublicKey = "certificatePublicKey";
  static const _certificatePrivateKey = "certificatePrivateKey";
  static late final SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Certificate? getCert() {
    final String? arn = _pref.getString(_certificateArnKey);
    final String? id = _pref.getString(_certificateIdKey);
    final String? pem = _pref.getString(_certificatePemKey);
    final String? public = _pref.getString(_certificatePublicKey);
    final String? private = _pref.getString(_certificatePrivateKey);

    return (arn != null &&
            id != null &&
            pem != null &&
            public != null &&
            private != null)
        ? Certificate(
            arn: arn,
            id: id,
            pem: pem,
            pair: KeyPair(privateKey: private, publicKey: public))
        : null;
  }

  static void updateCert(Certificate cert) {
    _pref.setString(_certificateArnKey, cert.arn);
    _pref.setString(_certificateIdKey, cert.id);
    _pref.setString(_certificatePemKey, cert.pem);
    _pref.setString(_certificatePublicKey, cert.pair.publicKey);
    _pref.setString(_certificatePrivateKey, cert.pair.privateKey);
  }
}
