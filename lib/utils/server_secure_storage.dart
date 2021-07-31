import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServerSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyServerIp = 'server_ip';

  static Future setServerIp(String serverIp) async {
    await _storage.write(key: _keyServerIp, value: serverIp);
  }

  static Future<String> getServerIp() async {
    var _serverIp = await _storage.read(key: _keyServerIp);
    if (_serverIp == null) {
      await _storage.write(key: _keyServerIp, value: '192.168.0.3');
      _serverIp = await _storage.read(key: _keyServerIp);
    }
    return _serverIp!;
  }
}
