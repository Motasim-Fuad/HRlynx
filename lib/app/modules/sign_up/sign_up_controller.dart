import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../otp_verification/otp_verification_controller.dart';
import '../otp_verification/otp_verification_view.dart';

class SignUpController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;
  var isChecked = false.obs;


  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }
  Future<void> signUpUser() async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final body = {
        "email": email.value.trim(),
        "password": password.value.trim(),
        "password2": confirmPassword.value.trim(), // ✅ Required by API
      };

      final response = await _authRepo.signup(body);

      if (response['success'] == true) {
        Get.snackbar("Success", response['message']);
        // Navigate to OTP screen, if needed
        // ✅ Pass email to OtpController before navigating
        final otpController = Get.put(OtpController());
        otpController.email.value = email.value;

        Get.to(() => OtpVerificationScreen());
      } else {
        Get.snackbar("Failed", response['message'] ?? "Signup failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("signup error = $e");
    } finally {
      isLoading.value = false;
    }
  }

}
