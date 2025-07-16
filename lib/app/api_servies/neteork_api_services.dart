import 'dart:convert';
import 'package:damaged303/app/api_servies/token.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices {
  /// ✅ Get appropriate token based on tokenType
  static Future<String?> getToken(String tokenType) async {
    switch (tokenType) {
      case 'otp':
        return await TokenStorage.getOtpAccessToken();
      case 'reset':
        return await TokenStorage.getResetAccessToken();
      case 'login':
      default:
        return await TokenStorage.getLoginAccessToken();
    }
  }

  /// ✅ Build headers with optional auth
  static Future<Map<String, String>> getHeaders({
    bool withAuth = true,
    String tokenType = 'login',
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await getToken(tokenType);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// GET request
  static Future<dynamic> getApi(
      String url, {
        bool withAuth = true,
        String tokenType = 'login',
      }) async {
    final headers = await getHeaders(withAuth: withAuth, tokenType: tokenType);
    final response = await http.get(Uri.parse(url), headers: headers);
    return _handleResponse(response);
  }

  /// POST request
  static Future<dynamic> postApi(
      String url,
      dynamic body, {
        bool withAuth = true,
        String tokenType = 'login',
      }) async {
    final headers = await getHeaders(withAuth: withAuth, tokenType: tokenType);
    final response =
    await http.post(Uri.parse(url), body: jsonEncode(body), headers: headers);
    return _handleResponse(response);
  }

  /// PUT request
  static Future<dynamic> putApi(
      String url,
      dynamic body, {
        bool withAuth = true,
        String tokenType = 'login',
      }) async {
    final headers = await getHeaders(withAuth: withAuth, tokenType: tokenType);
    final response =
    await http.put(Uri.parse(url), body: jsonEncode(body), headers: headers);
    return _handleResponse(response);
  }

  /// DELETE request
  static Future<dynamic> deleteApi(
      String url, {
        dynamic body,
        bool withAuth = true,
        String tokenType = 'login',
      }) async {
    final headers = await getHeaders(withAuth: withAuth, tokenType: tokenType);
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  /// Handle API responses
  static dynamic _handleResponse(http.Response response) {
    print('🔎 Response Code: ${response.statusCode}');
    print('📦 Raw Response Body: ${response.body}');

    try {
      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        throw Exception(
            'API Error: ${response.statusCode} - ${responseBody.toString()}');
      }
    } catch (e) {
      throw FormatException('Unexpected response format: ${response.body}');
    }
  }
}
