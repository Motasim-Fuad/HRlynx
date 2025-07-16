import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/text_field.dart';
import 'package:damaged303/app/modules/log_in/log_in_controller.dart';
import 'package:damaged303/app/modules/log_in/log_in_view.dart';
import 'package:damaged303/app/modules/sign_up/sign_up_controller.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:damaged303/app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isObscured = true.obs;

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }
}

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final PasswordController passwordcontroller = Get.put(PasswordController());

  final SignUpController signUpController = Get.put(SignUpController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenWidth < 600 ? 60 : 90),
                        const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 26,
                              color: Color(0xFF1B1E28),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'Please complete and create account',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7D848D),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),

                        _label("Your Email"),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: 'arraihan815@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          onChanged: (value) => signUpController.email.value = value,
                        ),

                        const SizedBox(height: 20),

                        _label("Password"),
                        Obx(() => CustomTextFormField(
                          controller: passwordController,
                          hintText: 'Enter your new Password',
                          keyboardType: TextInputType.text,
                          obscureText: passwordcontroller.isObscured.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordcontroller.isObscured.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: passwordcontroller.toggleObscureText,
                          ),
                          onChanged: (value) =>
                          signUpController.password.value = value,
                        )),

                        const SizedBox(height: 20),

                        _label("Confirm Password"),
                        Obx(() => CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: 'Re-enter Password',
                          keyboardType: TextInputType.text,
                          obscureText: passwordcontroller.isObscured.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordcontroller.isObscured.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: passwordcontroller.toggleObscureText,
                          ),
                          onChanged: (value) =>
                          signUpController.confirmPassword.value = value,
                        )),

                        const SizedBox(height: 10),
                        const Text('Password must be 8 characters'),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Obx(() => Checkbox(
                              value: signUpController.isChecked.value,
                              onChanged: signUpController.toggleCheckbox,
                            )),
                            const Flexible(
                              child: Wrap(
                                children: [
                                  Text('I agree to the '),
                                  Text(
                                    'Terms of Use',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.primarycolor,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(' and '),
                                  Text(
                                    'Privacy Policy.',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.primarycolor,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Button(
                          title: 'Sign Up', onTap: () => signUpController.signUpUser(),
                          isLoading: signUpController.isLoading.value,
                        ),


                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () => Get.to(LogInView()),
                              child: Text(
                                'Log In',
                                style: TextStyle(color: AppColors.primarycolor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }


  Widget _label(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xff050505),
          ),
        ),
      ],
    );
  }
}

