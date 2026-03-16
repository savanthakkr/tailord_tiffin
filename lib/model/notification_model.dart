class NotificationModel {
  final int notificationId;
  final String title;
  final String message;
  final int isRead;
  final String createdAt;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: int.tryParse(json['notification_id'].toString()) ?? 0,
      title: json['title'] ?? "",
      message: json['message'] ?? "",
      isRead: int.tryParse(json['is_read'].toString()) ?? 0,
      createdAt: json['created_at'] ?? "",
    );
  }
}