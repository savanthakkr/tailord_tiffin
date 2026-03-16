import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../utils/prefs.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  late NotificationController notificationCtrl;

  String? authToken,userId;

  @override
  void initState() {
    super.initState();

    notificationCtrl = Get.find<NotificationController>();

    authToken = Prefs.shared.getString(Prefs.authToken);
    userId = Prefs.shared.getString(Prefs.userId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationCtrl.getNotifications(authToken!);
      notificationCtrl.markAsRead(authToken!);
    });
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<NotificationController>(
      builder: (ctrl) {

        if (ctrl.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.notificationList.isEmpty) {
          return const Center(child: Text("No Notifications"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: ctrl.notificationList.length,
          itemBuilder: (context, index) {

            final notification = ctrl.notificationList[index];

            return Card(
              elevation: 1,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(
                  notification.createdAt,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}