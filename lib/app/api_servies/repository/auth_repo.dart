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


}
