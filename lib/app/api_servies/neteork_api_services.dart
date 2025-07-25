import 'dart:convert';
import 'dart:io';
import 'package:damaged303/app/api_servies/token.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

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
//   static dynamic _handleResponse(http.Response response) {
//     print('🔎 Response Code: ${response.statusCode}');
//     print('📦 Raw Response Body: ${response.body}');
//
//     try {
//       final responseBody = jsonDecode(response.body);
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return responseBody;
//       } else {
//         throw Exception(
//             'API Error: ${response.statusCode} - ${responseBody.toString()}');
//       }
//     } catch (e) {
//       throw FormatException('Unexpected response format: ${response.body}');
//     }
//   }


  // NEW METHOD: For multipart data with file upload
  static Future<dynamic> postMultipartApi(
      String url,
      Map<String, dynamic> fields, {
        File? imageFile,
        String imageFieldName = 'profile_picture',
        bool withAuth = true,
        String tokenType = 'access',
      }) async {
    try {
      print('🌐 Multipart POST URL: $url');
      print('📤 Fields: $fields');
      print('🖼️ Image: ${imageFile?.path}');

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add authorization header if required
      if (withAuth) {
        String? token;
        if (tokenType == 'login') {
          token = await TokenStorage.getLoginAccessToken();
        } else {
          token = await TokenStorage.getLoginAccessToken();
        }

        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }

      // Add text fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add image file if provided
      if (imageFile != null && imageFile.existsSync()) {
        String fileName = imageFile.path.split('/').last;
        String fileExtension = fileName.split('.').last.toLowerCase();

        // Determine MIME type based on file extension
        MediaType mediaType;
        switch (fileExtension) {
          case 'jpg':
          case 'jpeg':
            mediaType = MediaType('image', 'jpeg');
            break;
          case 'png':
            mediaType = MediaType('image', 'png');
            break;
          case 'gif':
            mediaType = MediaType('image', 'gif');
            break;
          case 'webp':
            mediaType = MediaType('image', 'webp');
            break;
          default:
            mediaType = MediaType('image', 'jpeg'); // default
        }

        var multipartFile = await http.MultipartFile.fromPath(
          imageFieldName,
          imageFile.path,
          contentType: mediaType,
          filename: fileName,
        );

        request.files.add(multipartFile);
        print('✅ Image file added: $fileName (${mediaType.toString()})');
      }

      print('🚀 Sending multipart request...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('🔎 Response Code: ${response.statusCode}');
      print('📦 Raw Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        print('✅ Multipart Success: $responseData');
        return responseData;
      } else {
        var errorData = jsonDecode(response.body);
        print('❌ Multipart Error: $errorData');
        throw Exception('API Error: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('❌ Multipart Exception: $e');
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('🔎 Response Code: ${response.statusCode}');

    print('📦 Raw Response Body: ${response.body}');

    try {
      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        // More detailed error message
        final errorMsg = responseBody['message'] ??
            responseBody['detail'] ??
            'Unknown error (${response.statusCode})';
        throw Exception('API Error: $errorMsg');
      }
    } catch (e) {
      throw FormatException('Unexpected response format: ${response.body}');
    }
  }

}




