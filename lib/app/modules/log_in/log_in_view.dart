import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:damaged303/app/modules/log_in/log_in_controller.dart';
import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/text_field.dart';
import 'package:damaged303/app/modules/foret_password/forget_password_view.dart';
import 'package:damaged303/app/modules/sign_up/sign_up_view.dart';
import 'package:damaged303/app/modules/terms_of_use/terms_of_use.dart';
import 'package:damaged303/app/common_widgets/privacy_policy.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:damaged303/app/utils/app_images.dart';

import 'googleSingUpController.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    final googleSingUpController = Get.put(GoogleSignUpController());

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth < 500 ? double.infinity : 400,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: height * 0.1),
                    const Text(
                      'Log In',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please log in to continue',
                      style: TextStyle(fontSize: 16, color: Color(0xFF7D848D)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    // Email
                    _buildLabel('Your Email'),
                    CustomTextFormField(
                      controller: controller.emailController,
                      hintText: 'example@email.com',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildLabel('Password'),
                    Obx(() => CustomTextFormField(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      obscureText: controller.isObscured.value,
                      keyboardType: TextInputType.text,
                      suffixIcon: IconButton(
                        icon: Icon(controller.isObscured.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: controller.toggleObscureText,
                      ),
                    )),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.to(ForgetPassword()),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primarycolor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Terms
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Checkbox(
                          value: controller.isChecked.value,
                          onChanged: controller.toggleCheckbox,
                          activeColor: AppColors.primarycolor,
                        )),
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text('I agree to the '),
                              GestureDetector(
                                onTap: () => Get.to(TermsOfUse()),
                                child: Text(
                                  'Terms of Use',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.primarycolor,
                                  ),
                                ),
                              ),
                              const Text(' and '),
                              GestureDetector(
                                onTap: () => Get.to(PrivacyPolicy()),
                                child: Text(
                                  'Privacy Policy.',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.primarycolor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    Obx(() => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : GestureDetector(
                      onTap: controller.loginUser,
                      child: const Button(title: 'Log In'),
                    )),

                    const SizedBox(height: 20),

                    // Sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Get.to(SignUp()),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: AppColors.primarycolor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Or connect',
                      style: TextStyle(fontSize: 14, color: Color(0xFF707B81)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => print("Apple tapped"),
                          child: Image.asset(AppImages.apple, height: 40),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => googleSingUpController.handleGoogleSignUp(),
                          child: Image.asset(AppImages.google, height: 40),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff050505),
        ),
      ),
    );
  }
}
