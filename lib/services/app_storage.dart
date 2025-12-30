import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final _secureStorage = FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  static Future<String?> read(String key) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await _secureStorage.read(key: key);
    }
  }

  static Future<void> delete(String key) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      await _secureStorage.delete(key: key);
    }
  }

  static Future<void> deleteAll() async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } else {
      await _secureStorage.deleteAll();
    }
  }
}