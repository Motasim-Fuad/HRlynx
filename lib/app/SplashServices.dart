// splash_service.dart
import 'package:damaged303/app/api_servies/token.dart';
import 'package:damaged303/app/modules/main_screen/main_screen_view.dart';
import 'package:damaged303/app/modules/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

class SplashService {
  Future<void> checkLoginStatus() async {
    final token = await TokenStorage.getLoginAccessToken();

    if (token != null && token.isNotEmpty) {
      // Navigate to MainScreen
      Get.offAll(() => MainScreen());
    } else {
      // Navigate to SplashScreen
      Get.offAll(() => SplashScreen());
    }
  }
}
