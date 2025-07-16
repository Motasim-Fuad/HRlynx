import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Login tokens
  static const _loginAccessTokenKey = 'login_access_token';
  static const _loginRefreshTokenKey = 'login_refresh_token';

  // OTP tokens
  static const _otpAccessTokenKey = 'otp_access_token';
  static const _otpRefreshTokenKey = 'otp_refresh_token';

  // Reset password tokens
  static const _resetAccessTokenKey = 'reset_access_token';
  static const _resetRefreshTokenKey = 'reset_refresh_token';

  /// ===== LOGIN TOKENS =====
  static Future<void> saveLoginTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginAccessTokenKey, accessToken);
    await prefs.setString(_loginRefreshTokenKey, refreshToken);
  }

  static Future<String?> getLoginAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginAccessTokenKey);
  }

  static Future<String?> getLoginRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginRefreshTokenKey);
  }

  /// ===== OTP TOKENS =====
  static Future<void> saveOtpTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_otpAccessTokenKey, accessToken);
    await prefs.setString(_otpRefreshTokenKey, refreshToken);
  }

  static Future<String?> getOtpAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_otpAccessTokenKey);
  }

  static Future<String?> getOtpRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_otpRefreshTokenKey);
  }

  /// ===== RESET PASSWORD TOKENS =====
  static Future<void> saveResetTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resetAccessTokenKey, accessToken);
    await prefs.setString(_resetRefreshTokenKey, refreshToken);
  }

  static Future<String?> getResetAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resetAccessTokenKey);
  }

  static Future<String?> getResetRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resetRefreshTokenKey);
  }



  //Clear login token

  static Future<void> clearLoginTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginAccessTokenKey);
    await prefs.remove(_loginRefreshTokenKey);
  }

  /// ===== CLEAR TOKENS =====
  static Future<void> clearAllTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginAccessTokenKey);
    await prefs.remove(_loginRefreshTokenKey);
    await prefs.remove(_otpAccessTokenKey);
    await prefs.remove(_otpRefreshTokenKey);
    await prefs.remove(_resetAccessTokenKey);
    await prefs.remove(_resetRefreshTokenKey);
  }
}
