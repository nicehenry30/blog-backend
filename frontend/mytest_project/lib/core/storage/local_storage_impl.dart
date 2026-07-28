import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences preferences;

  static const String _tokenKey = 'auth_token';

  LocalStorageImpl(this.preferences);

  @override
  Future<void> saveToken(String token) async {
    await preferences.setString(_tokenKey, token);
  }

  @override
  String? getToken() {
    return preferences.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    await preferences.remove(_tokenKey);
  }

  @override
  bool hasToken() {
    return preferences.containsKey(_tokenKey);
  }
}

