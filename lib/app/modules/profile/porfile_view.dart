import 'package:damaged303/app/modules/change_password/change_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/privacy_policy.dart';
import 'package:damaged303/app/modules/changed_subscription/changed_subscription_view.dart';
import 'package:damaged303/app/modules/log_in/log_in_view.dart';
import 'package:damaged303/app/modules/notifications/notifications_view.dart';
import 'package:damaged303/app/modules/terms_of_use/terms_of_use.dart';

import 'package:damaged303/app/utils/app_images.dart';

import 'logoutHelper.dart';

class PorfileView extends StatelessWidget {
  const PorfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(AppImages.profie),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Rayhan Mia',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF1B1E28),
                ),
              ),
            ),
            Center(
              child: Text(
                'rayhantmt@gmail.com',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF7D848D),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Button(
              title: 'Subscribe Now',
              onTap: () => Get.to(Subscription(),

              ),
            ),


            /// Notifications
            ListTile(
              leading: Icon(Icons.notifications_active_outlined),
              title: Text('Notifications'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(NotificationsView()),
            ),


            /// Privacy Policy
            ListTile(
              leading: Icon(Icons.insert_drive_file_outlined),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(PrivacyPolicy()),
            ),


            /// Terms of Use
            ListTile(
              leading: Icon(Icons.insert_drive_file_outlined),
              title: Text('Terms of Use'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(TermsOfUse()),
            ),


            /// Change Password
            ListTile(
              leading: Icon(Icons.lock_outline_sharp),
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Get.to(ChangePassword()),
            ),


            /// Logout
            ListTile(
              leading: Icon(Icons.logout_outlined, color: Color(0xffD40606)),
              title: Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xffD40606),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(child: Text('Log Out')),
                    content: Text(
                      'Are you sure you want to log out?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [


                      GestureDetector(

                        onTap: ()async{
                          Navigator.of(context).pop();
                          await LogoutHelper.logout();
                        },
                        child:Container(
                          width: double.infinity,
                          child:  Text("Yes",textAlign: TextAlign.center,style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child:Container(
                          width: double.infinity,
                          child:  Text("No",textAlign: TextAlign.center,style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,

                          ),),
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
