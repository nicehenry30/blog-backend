abstract interface class LocalStorage {
  Future<void> saveToken(String token);

  String? getToken();

  Future<void> removeToken();

  bool hasToken();
}
