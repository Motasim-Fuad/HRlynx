import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../forgotPassOtpVerification/forgotPassOtpView.dart';
import '../otp_verification/otp_verification_view.dart';

class ForgetPasswordController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final email = ''.obs;
  final isLoading = false.obs;

  Future<void> submitForgotPassword() async {
    if (email.value.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "email": email.value.trim(),
      };

      final response = await _authRepo.forgotPassword(body);

      if (response['success'] == true) {
        Get.snackbar("Success", response['message'] ?? "Check your email");

        // Navigate to OTP screen or confirmation
        Get.to(() => Forgotpassotpview(), arguments: email.value.trim());

      } else {
        Get.snackbar("Failed", response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
