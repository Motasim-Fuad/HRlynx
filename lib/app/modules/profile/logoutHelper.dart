import 'package:damaged303/app/modules/log_in/log_in_view.dart';
import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/token.dart';


class LogoutHelper {
  static Future<void> logout() async {
    final _authRepo = AuthRepository();

    try {
      // Call logout API
      await _authRepo.LogOut();
    } catch (e) {
      print('⚠️ Logout API failed: $e');
    } finally {
      // Clear saved tokens
      await TokenStorage.clearLoginTokens();

      // Navigate to login screen and remove all previous routes
      Get.offAll(() => LogInView());
    }
  }
}
