import 'dart:io';

import '../api_Constant.dart';
import '../neteork_api_services.dart';
import '../token.dart';

class AuthRepository {
  final _api = NetworkApiServices();

  // ---------- Persona ----------
  Future<dynamic> getParsonaType() async {
    String url = "${ApiConstants.baseUrl}/api/aipersona/personas/";
    return await NetworkApiServices.getApi(url, withAuth: false);
  }

  Future<dynamic> setParsonaType(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/aipersona/select-persona/";
    return await NetworkApiServices.postApi(url, body, withAuth: true, tokenType: 'login');
  }

  // ---------- Auth ----------
  Future<dynamic> login(String email, String password) async {
    final body = {
      "email": email,
      "password": password,
    };
    String url = "${ApiConstants.baseUrl}/api/auth/login/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  Future<dynamic> signup(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/register/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  Future<dynamic> singUpOtp(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/verify-email/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  Future<dynamic> resendOtp(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/resend-otp/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  // ---------- Logout ----------
  Future<dynamic> LogOut() async {
    String url = "${ApiConstants.baseUrl}/api/auth/logout/";

    // Get the refresh token first
    final refreshToken = await TokenStorage.getLoginRefreshToken();

    // Ensure it's not null
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception("No refresh token found for logout.");
    }

    // Send it in the body as expected by backend
    final body = {
      "refresh": refreshToken,
    };

    return await NetworkApiServices.postApi(
      url,
      body,
      withAuth: true,
      tokenType: 'login',
    );
  }



  // ---------- Forgot Password ----------
  Future<dynamic> forgotPassword(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/password/reset-request/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  Future<dynamic> forgotPasswordOtpVeryfication(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/password/reset-verify-otp/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  Future<dynamic> updatePassword(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/password/reset-confirm/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }
  Future<dynamic> resendForgotPasswordOtp(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/resend-otp/";
    return await NetworkApiServices.postApi(url, body, withAuth: false);
  }

  // ---------- Google SignUp ----------
  Future<bool> googleSignUpAndSetPersona({
    required String email,
    required String name,
    required String provider,
    required Map<String, dynamic> personaBody,
  }) async {
    try {
      final url = "${ApiConstants.baseUrl}/api/auth/social-auth/";
      final body = {
        "email": email,
        "name": name,
        "provider": provider,
      };

      print("📤 Sending social login payload: $body");

      final response = await NetworkApiServices.postApi(url, body, withAuth: false);

      final data = response['data'];
      final access = data['access'];
      final refresh = data['refresh'];

      await TokenStorage.saveLoginTokens(access, refresh);

      await setParsonaType(personaBody); // uses login token

      return true;
    } catch (e) {
      print('❌ googleSignUpAndSetPersona Error: $e');
      return false;
    }
  }

  // ---------- Profile ----------
  Future<dynamic> getUserProfile() async {
    String url = "${ApiConstants.baseUrl}/api/profile/";
    return await NetworkApiServices.getApi(url, tokenType: 'login');
  }

  Future<dynamic> updateUserProfile(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/profile/update/";
    return await NetworkApiServices.putApi(url, body, tokenType: 'login');
  }

  Future<dynamic> deleteAccount() async {
    String url = "${ApiConstants.baseUrl}/api/auth/delete/";
    return await NetworkApiServices.deleteApi(url, tokenType: 'login');
  }

  Future<dynamic> changePassword(Map<String, dynamic> body) async {
    String url = "${ApiConstants.baseUrl}/api/auth/password/change/";
    return await NetworkApiServices.postApi(
      url,
      body,
      withAuth: true,
      tokenType: 'login', // Use access token from login
    );
  }


  Future<dynamic> uploadProfileData(Map<String, dynamic> body, {File? imageFile}) async {
    String url = "${ApiConstants.baseUrl}/api/auth/profile/";

    // Remove image path from body if it exists
    Map<String, dynamic> cleanBody = Map.from(body);
    cleanBody.remove('profile_picture');

    return await NetworkApiServices.postMultipartApi(
      url,
      cleanBody,
      imageFile: imageFile,
      imageFieldName: 'profile_picture',
      withAuth: true,
      tokenType: 'login',
    );
  }
  Future<dynamic> fetchProfileData() async {
    String url = "${ApiConstants.baseUrl}/api/auth/profile/"; // This is correct!
    return await NetworkApiServices.getApi(url, withAuth: true, tokenType: 'login');
  }

// ---------- home ----------
      //---For Chat Start
  Future<dynamic> getAllAiPersona() async {
    String url = "${ApiConstants.baseUrl}/api/aipersona/personas/";
    return await NetworkApiServices.getApi(url, withAuth: true, tokenType: 'login');
  }


  Future<String?> createSession(int personaId) async {
    try {
      String url = "${ApiConstants.baseUrl}/api/chat/sessions/create/";

      final body = {
        "persona_id": personaId,
      };

      final response = await NetworkApiServices.postApi(
        url,
        body,
        withAuth: true,
        tokenType: 'login',
      );

      print('✅ Session creation response: $response');

      if (response != null &&
          response['session'] != null &&
          response['session']['id'] != null) {
        return response['session']['id'].toString();
      } else {
        throw Exception('Invalid session response format');
      }
    } catch (e) {
      print('❌ Error creating session: $e');
      return null;
    }
  }

      //---For Chat end


// ---------- chat ----------
  Future<dynamic> AiSuggestions(int  personaId) async {
    String url = "${ApiConstants.baseUrl}/api/chat/suggestions/?persona_id=$personaId";
    return await NetworkApiServices.getApi(url, withAuth: true, tokenType: 'login');
  }

  Future<dynamic> fetchPersonaChatHistory(int  personaId) async {
    String url = "${ApiConstants.baseUrl}/api/chat/personas/$personaId/sessions/";
    return await NetworkApiServices.getApi(url, withAuth: true, tokenType: 'login');
  }


  Future<dynamic> fetchSessionsDetails(int sessionId) async {  // 👈 CHANGE TO STRING
    print("fuadAuth1");
    final url = "${ApiConstants.baseUrl}/api/chat/sessions/$sessionId/";
    print("fuadAuth2");
    print('🌐 Fetching session details for: $url');
    print("fuadAuth3");

    try {
      print("fuadAuth4");
      final response = await NetworkApiServices.getApi(url, withAuth: true, tokenType: 'login');
      print("fuadAuth5");
      print('✅ Session details response: $response');
      print("fuadAuth6$response");
      return response;

    } catch (e) {
      print("fuadAuth7");
      print('❌❌❌❌❌❌❌❌ Error fetching session details: $e');
      return null;
    }
  }


  Future<dynamic> deleteHistory(int  session_id) async {
    String url = "${ApiConstants.baseUrl}/api/chat/sessions/${session_id}/delete/";
    return await NetworkApiServices.deleteApi(url, withAuth: true, tokenType: 'login');
  }




}
