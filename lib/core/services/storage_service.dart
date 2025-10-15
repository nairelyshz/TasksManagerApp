import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  StorageService(this._secureStorage, this._preferences);

  // Singleton
  static StorageService? _instance;

  static Future<StorageService> getInstance() async {
    if (_instance != null) return _instance!;

    const secureStorage = FlutterSecureStorage();
    final preferences = await SharedPreferences.getInstance();

    _instance = StorageService(secureStorage, preferences);
    return _instance!;
  }

  // ========== Secure Storage (Tokens) ==========

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageConstants.accessToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: StorageConstants.accessToken);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ========== Shared Preferences ==========

  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
    await _preferences.clear();
  }
}
