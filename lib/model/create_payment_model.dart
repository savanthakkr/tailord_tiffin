import 'dart:convert';

CreatePaymentModel createPaymentModelFromJson(String str) => CreatePaymentModel.fromJson(json.decode(str));

String createPaymentModelToJson(CreatePaymentModel data) => json.encode(data.toJson());

class CreatePaymentModel {
  bool? status;
  int? paymentId;
  String? encRequest;
  String? accessCode;
  String? message;

  CreatePaymentModel({
    this.status,
    this.paymentId,
    this.encRequest,
    this.accessCode,
    this.message,
  });

  factory CreatePaymentModel.fromJson(Map<String, dynamic> json) => CreatePaymentModel(
    status: json["status"],
    paymentId: json["payment_id"],
    encRequest: json["encRequest"],
    accessCode: json["accessCode"],
    message: json["message"] != null ? json["message"] : "",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "payment_id": paymentId,
    "encRequest": encRequest,
    "accessCode": accessCode,
    "message": message,
  };
}
