import 'package:damaged303/app/modules/log_in/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_servies/repository/auth_repo.dart';
import '../../api_servies/token.dart';
import '../main_screen/main_screen_view.dart';

class LogInController extends GetxController {


  final userController = Get.put(UserController());
  final AuthRepository _authRepo = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isObscured = true.obs;
  final isChecked = false.obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) return;

    if (!isChecked.value) {
      Get.snackbar("Terms Not Accepted", "Please agree to the Terms and Privacy Policy");
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      isLoading.value = true;
      final response = await _authRepo.login(email, password);

      final data = response['data'];
      final access = data?['access'];
      final refresh = data?['refresh'];


      userController.setUserEmail(email);

      if (access != null && refresh != null) {
        await TokenStorage.saveLoginTokens(access, refresh);
        Get.snackbar("Success", response['message'] ?? "Login successful");
        Get.to(() => MainScreen());
      } else {
        Get.snackbar("Failed", "Login token missing.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
