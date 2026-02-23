import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  // Create a single storage instance
  static final _storage = FlutterSecureStorage();

  // Save a string (like access or refresh token)
  static Future<void> setString(Map<String, String> values) async {
    for (var entry in values.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  static Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  // Save a boolean
  static Future<void> setBool(String key, bool value) async {
    await _storage.write(key: key, value: value ? 'true' : 'false');
  }

  static Future<bool?> getBool(String key) async {
    final val = await _storage.read(key: key);
    if (val == null) return null;
    return val == 'true';
  }

  // Save an integer
  static Future<void> setInt(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }

  static Future<int?> getInt(String key) async {
    final val = await _storage.read(key: key);
    if (val == null) return null;
    return int.tryParse(val);
  }

  // Remove keys
  static Future<void> remove(List<String> keys) async {
    for (var key in keys) {
      await _storage.delete(key: key);
    }
  }

  // Clear all data
  static Future<void> clearLocalStorage() async {
    await _storage.deleteAll();
  }
}
