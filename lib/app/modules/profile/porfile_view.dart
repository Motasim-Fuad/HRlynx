import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/privacy_policy.dart';
import 'package:damaged303/app/common_widgets/profile_helper_text.dart';
import 'package:damaged303/app/modules/changed_subscription/changed_subscription_view.dart';

import 'package:damaged303/app/modules/log_in/log_in_view.dart';
import 'package:damaged303/app/modules/notifications/notifications_view.dart';
import 'package:damaged303/app/modules/terms_of_use/terms_of_use.dart';
import 'package:damaged303/app/modules/update_password/update_password.dart';

import 'package:damaged303/app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logoutHelper.dart';

class PorfileView extends StatelessWidget {
  const PorfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(AppImages.profie),
          ),

          Text(
            'Rayhan Mia',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Color(0xFF1B1E28),
            ),
          ),
          Text(
            'rayhantmt@gmail.com',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF7D848D),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(Subscription());
            },
            child: Button(title: 'Subscribe Now'),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Get.to(NotificationsView());
            },
            child: ProfileHelp(
              icon: Icons.notifications_active_outlined,
              text: 'Notifications',
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Get.to(PrivacyPolicy());
            },
            child: ProfileHelp(
              icon: Icons.insert_drive_file_outlined,
              text: 'Privacy Policy',
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Get.to(TermsOfUse());
            },
            child: ProfileHelp(
              icon: Icons.insert_drive_file_outlined,
              text: 'Terms of Use',
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Get.to(UpdatePassword());
            },
            child: ProfileHelp(
              icon: Icons.lock_outline_sharp,
              text: 'Change Password',
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Log Out', textAlign: TextAlign.center),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Are you sure you want to log out?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 24),
                      GestureDetector(
                        onTap: () async {
                          await LogoutHelper.logout();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.logout_outlined, color: Color(0xffD40606)),
                      SizedBox(width: 8),
                      Text(
                        'Log out',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xffD40606),
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_outlined, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
