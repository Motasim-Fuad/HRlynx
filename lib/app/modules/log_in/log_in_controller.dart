// log_in_controller.dart
import 'package:damaged303/app/modules/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/token.dart';
import '../main_screen/main_screen_view.dart';

class LogInController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isObscured = true.obs;
  final isChecked = false.obs;

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authRepo.login(email, password);

      final data = response['data'];
      final access = data?['access'];
      final refresh = data?['refresh'];

      if (access != null && refresh != null) {
        await TokenStorage.saveLoginTokens(access, refresh);
        Get.snackbar("Success", response['message'] ?? "Login successful");

        print("api success: ${response['message']}");
        Get.to(() => MainScreen());
      } else {
        print("❌ Token missing in login response: $data");
        Get.snackbar("Failed", "Login token missing.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("❌ Login exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
