import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isObscuredNew = true.obs;
  var isObscuredConfirm = true.obs;

  void toggleObscureTextNew() {
    isObscuredNew.value = !isObscuredNew.value;
  }

  void toggleObscureTextConfirm() {
    isObscuredConfirm.value = !isObscuredConfirm.value;
  }
}

final PasswordController passwordcontroller = Get.put(PasswordController());

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: Color(0xFF1B1E28),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The password must be different than previous',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF7D848D),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Enter your old password'),
                ),
              ],
            ),
            Obx(
              () => CustomTextFormField(
                hintText: 'Old Password',
                keyboardType: TextInputType.text,
                obscureText: passwordcontroller.isObscuredNew.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordcontroller.isObscuredNew.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: passwordcontroller.toggleObscureTextNew,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Enter your new password'),
                ),
              ],
            ),
            Obx(
              () => CustomTextFormField(
                hintText: 'New Password',
                keyboardType: TextInputType.text,
                obscureText: passwordcontroller.isObscuredConfirm.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordcontroller.isObscuredConfirm.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: passwordcontroller.toggleObscureTextConfirm,
                ),
              ),
            ),

            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Text('Password must be 8 character'),
                ),
              ],
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => print('password reseted'),
              child: Button(title: 'Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
