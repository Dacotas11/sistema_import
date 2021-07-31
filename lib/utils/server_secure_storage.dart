import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyServerIp = 'server_ip';

  static Future initServerIp() async {
    // await _storage.write(key: _keyServerIp, value: '192.168.0.3');
    // // final serverIp = await _storage.read(key: _keyServerIp);

    // // if (serverIp == null) {
    // //   await _storage.write(key: _keyServerIp, value: '192.168.0.3');
    // // }

    try {
      await _storage.read(key: _keyServerIp);
    } catch (e) {
      await _storage.write(key: _keyServerIp, value: '192.168.0.5');
    }
  }

  static Future setServerIp(String serverIp) async {
    await _storage.write(key: _keyServerIp, value: serverIp);
  }

  static Future getServerIp() async => await _storage.read(key: _keyServerIp);
}
