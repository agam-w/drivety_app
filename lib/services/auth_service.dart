import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userRoleKey = 'user_role';

  // Save user authentication data
  static Future<bool> login(
      String token, String userId, String userName, String userRole) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userIdKey, userId);
      await prefs.setString(_userNameKey, userName);
      await prefs.setString(_userRoleKey, userRole);
      return true;
    } catch (e) {
      print('Error saving authentication data: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Get current user data
  static Future<Map<String, String?>> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'userId': prefs.getString(_userIdKey),
        'userName': prefs.getString(_userNameKey),
        'userRole': prefs.getString(_userRoleKey),
      };
    } catch (e) {
      print('Error getting user data: $e');
      return {};
    }
  }

  // Clear all authentication data
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userRoleKey);
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
}
