import 'package:damaged303/app/modules/notifications/notificatins_model.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificatinsModel> notifications =
        Notificatinsdata().notificationsdata;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xff1B1E28),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (BuildContext cntext, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(notifications[index].name),
                              Text(notifications[index].notification_time),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(notifications[index].hint_notifications),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),

                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primarycolor,
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: Center(
                        child: Text(
                          notifications[index].notification_count,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Divider(),
              ),
            ],
          );
        },
      ),
    );
  }
}
