import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling local storage operations using SharedPreferences
///
/// This service provides methods for saving and reading simple local values.
///
/// Usage:
/// ```dart
/// await LocalStorageService.saveData(key: 'token', value: 'abc123');
/// final token = await LocalStorageService.readData(key: 'token');
/// ```
class LocalStorageService {
  LocalStorageService._();

  /// Save string data to local storage
  /// 
  /// [key] - The key to store the value under
  /// [value] - The string value to store
  static Future<void> saveData({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Read string data from local storage
  /// 
  /// [key] - The key to retrieve the value from
  /// Returns the stored string value or null if not found
  static Future<String?> readData({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Save boolean data to local storage
  /// 
  /// [key] - The key to store the value under
  /// [value] - The boolean value to store
  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// Read boolean data from local storage
  /// 
  /// [key] - The key to retrieve the value from
  /// Returns the stored boolean value or null if not found
  static Future<bool?> readBool({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  /// Save integer data to local storage
  /// 
  /// [key] - The key to store the value under
  /// [value] - The integer value to store
  static Future<void> saveInt({
    required String key,
    required int value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  /// Read integer data from local storage
  /// 
  /// [key] - The key to retrieve the value from
  /// Returns the stored integer value or null if not found
  static Future<int?> readInt({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  /// Remove data from local storage
  /// 
  /// [key] - The key to remove
  static Future<void> removeData({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Clear all data from local storage
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Check if a key exists in local storage
  /// 
  /// [key] - The key to check
  /// Returns true if the key exists, false otherwise
  static Future<bool> containsKey({
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
