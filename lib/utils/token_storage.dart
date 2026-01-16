import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class TokenStorage {
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // Save access token
  static Future<bool> saveAccessToken(String token) async {
    await init();
    return await _prefs!.setString(ApiConfig.accessTokenKey, token);
  }
  
  // Get access token
  static Future<String?> getAccessToken() async {
    await init();
    return _prefs!.getString(ApiConfig.accessTokenKey);
  }
  
  // Check if token exists
  static Future<bool> hasToken() async {
    await init();
    return _prefs!.containsKey(ApiConfig.accessTokenKey);
  }
  
  // Clear all tokens
  static Future<bool> clearTokens() async {
    await init();
    return await _prefs!.remove(ApiConfig.accessTokenKey);
  }
}

