class NotificatinsModel {
  final String name;
  final String hint_notifications;
  final String notification_time;
  final String notification_count;

  NotificatinsModel({
    required this.notification_time,
    required this.name,
    required this.hint_notifications,
    required this.notification_count,
  });
}

class Notificatinsdata {
  final List<NotificatinsModel> notificationsdata = [
    NotificatinsModel(
      notification_time: '12:44 PM',
      name: "Jacob Davis",
      hint_notifications: 'Hi there! I"d love to help you with....',
      notification_count: '3',
    ),
    NotificatinsModel(
      notification_time: '12:44 PM',
      name: 'La Phili s',
      hint_notifications: 'Hi there! I"d love to help you with....',
      notification_count: '5',
    ),
  ];
}
