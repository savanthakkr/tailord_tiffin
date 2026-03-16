import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tailoredtiffin/api/api_manager.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {

  List<NotificationModel> notificationList = [];
  int unreadCount = 0;
  bool isLoading = false;

  Future<void> getNotifications(String userToken) async {

    isLoading = true;
    update();

    try {

      final response = await http.get(
        Uri.parse("${ApiManager.baseUrl}/user/get_notifications"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      final data = jsonDecode(response.body);

      print(data);
      print("adasdasdsad");

      if (data['status'] == "success") {

        notificationList = (data['data'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      }

    } catch (e) {
      print(e);
    }

    isLoading = false;
    update();
  }

  Future<void> getUnreadCount(String userToken) async {

    try {

      final response = await http.get(
        Uri.parse("${ApiManager.baseUrl}/user/get_unread_notification_count"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        unreadCount = data['data']['count'];
      }

      update();

    } catch (e) {
      print(e);
    }
  }

  Future<void> markAsRead(String userToken) async {

    try {

      await http.post(
        Uri.parse("${ApiManager.baseUrl}/user/mark_notifications_read"),
        headers: {
          "Authorization": "$userToken",
        },
      );

      unreadCount = 0;

      update();

    } catch (e) {
      print(e);
    }
  }
}