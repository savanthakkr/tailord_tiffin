// To parse this JSON data, do
//
//     final orderRespModel = orderRespModelFromJson(jsonString);

import 'dart:convert';

OrderRespModel orderRespModelFromJson(String str) => OrderRespModel.fromJson(json.decode(str));

String orderRespModelToJson(OrderRespModel data) => json.encode(data.toJson());

class OrderRespModel {
  String? status;
  String? msg;
  OrderResp? data;

  OrderRespModel({
    this.status,
    this.msg,
    this.data,
  });

  factory OrderRespModel.fromJson(Map<String, dynamic> json) => OrderRespModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : OrderResp.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class OrderResp {
  String? orderId;
  RazorpayData? razorpay;

  OrderResp({
    this.orderId,
    this.razorpay,
  });

  factory OrderResp.fromJson(Map<String, dynamic> json) => OrderResp(
    orderId: json["order_id"],
    razorpay: json["razorpay"] == null ? null : RazorpayData.fromJson(json["razorpay"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "razorpay": razorpay?.toJson(),
  };
}

class RazorpayData {
  String? key;
  String? orderId;
  String? amount;
  String? currency;

  RazorpayData({
    this.key,
    this.orderId,
    this.amount,
    this.currency,
  });

  factory RazorpayData.fromJson(Map<String, dynamic> json) => RazorpayData(
    key: json["key"],
    orderId: json["order_id"],
    amount: json["amount"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "order_id": orderId,
    "amount": amount,
    "currency": currency,
  };
}
