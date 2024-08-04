import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    return _prefs.getString(key);
  }

  static Future<void> updateData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> deleteData(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(value);
    await prefs.setString(key, jsonString);
  }

  static Future<Map<String, dynamic>?> getMap(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString == null) {
      return null;
    }
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap;
  }

  static Future<void> deleteMap(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}