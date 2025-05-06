import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/general.dart';

class StorageHelper {
  static SharedPreferences? _prefs;
  
  static Future<SharedPreferences> _getInstance() async {
    try {
      return _prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error getting SharedPreferences instance: $e');
      rethrow;
    }
  }

 static Future<String?> getString(String key) async {
    try {
      final prefs = await _getInstance();
      return prefs.getString(key);
    } catch (e) {
      debugPrint('Error getting string for key $key: $e');
      return null;
    }
  }

  static Future<bool> setString(String key, String value) async {
    try {
      final prefs = await _getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      debugPrint('Error setting string for key $key: $e');
      return false;
    }
  }

  static Future<List<String>?> getStringList(String key) async {
    try {
      final prefs = await _getInstance();
      return prefs.getStringList(key);
    } catch (e) {
      debugPrint('Error getting string list for key $key: $e');
      return null;
    }
  }

  static Future<bool> setStringList(String key, List<String> values) async {
    try {
      final prefs = await _getInstance();
      return await prefs.setStringList(key, values);
    } catch (e) {
      debugPrint('Error setting string list for key $key: $e');
      return false;
    }
  }

  static Future<bool> setInt(String key, int value) async {
    try {
      final prefs = await _getInstance();
      return await prefs.setInt(key, value);
    } catch (e) {
      debugPrint('Error setting int for key $key: $e');
      return false;
    }
  }

  static Future<int?> getInt(String key) async {
    try {
      final prefs = await _getInstance();
      return prefs.getInt(key);
    } catch (e) {
      debugPrint('Error getting int for key $key: $e');
      return null;
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await _getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('Error setting bool for key $key: $e');
      return false;
    }
  }

  static Future<bool?> getBool(String key) async {
    try {
      final prefs = await _getInstance();
      return prefs.getBool(key);
    } catch (e) {
      debugPrint('Error getting bool for key $key: $e');
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      final prefs = await _getInstance();
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('Error removing key $key: $e');
      return false;
    }
  }

  static Future<bool> checkKeyExist(String key) async {
    try {
      final prefs = await _getInstance();
      return prefs.containsKey(key); // Fixed: was hardcoded to 'value'
    } catch (e) {
      debugPrint('Error checking key existence for $key: $e');
      return false;
    }
  }

  static Future<bool> clear() async {
    try {
      final prefs = await _getInstance();
      return await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
      return false;
    }
  }

  static bool isDevTeam() {
    try {
      final devTeams = ['dang.phan.2', 'phap.nguyen.1'];
      final userName = _prefs?.getString(AppStateConfigConstant.USER_NAME);
      if (userName == null) return false;
      
      return devTeams.any((devTeam) => userName.contains(devTeam));
    } catch (e) {
      debugPrint('Error checking dev team: $e');
      return false;
    }
  }

  static String getStorageToken() {
    return _prefs?.getString(AppStateConfigConstant.JWT) ?? '';
  }
}
