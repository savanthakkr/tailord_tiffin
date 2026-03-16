import 'dart:convert';

VerifyPaymentModel verifyPaymentModelFromJson(String str) => VerifyPaymentModel.fromJson(json.decode(str));

String verifyPaymentModelToJson(VerifyPaymentModel data) => json.encode(data.toJson());

class VerifyPaymentModel {
  bool? status;
  String? paymentStatus;
  String? message;

  VerifyPaymentModel({
    this.status,
    this.paymentStatus,
    this.message,
  });

  factory VerifyPaymentModel.fromJson(Map<String, dynamic> json) => VerifyPaymentModel(
    status: json["status"],
    paymentStatus: json["payment_status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "payment_status": paymentStatus,
    "message": message,
  };
}