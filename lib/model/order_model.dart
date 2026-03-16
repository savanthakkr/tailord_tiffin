import 'dart:convert';

import 'order_detail_model.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? status;
  String? msg;
  List<OrderData>? data;

  OrderModel({
    this.status,
    this.msg,
    this.data,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<OrderData>.from(json["data"]!.map((x) => OrderData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OrderData {
  String? orderId;
  String? totalAmount;
  String? orderType;
  String? isPaid;
  String? status;
  DateTime? createdAt;
  String? deliveryDates;
  String? slot;

  List<Schedule>? schedules;
  List<Item>? items;

  OrderData({
    this.orderId,
    this.totalAmount,
    this.orderType,
    this.isPaid,
    this.status,
    this.createdAt,
    this.deliveryDates,
    this.slot,
    this.schedules,
    this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    orderId: json["order_id"]?.toString(),
    totalAmount: json["total_amount"]?.toString(),
    orderType: json["order_type"]?.toString(),
    isPaid: json["is_paid"]?.toString(),
    status: json["status"]?.toString(),

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),

    deliveryDates: json["delivery_dates"]?.toString(),

    slot: json["slot"]?.toString() ?? json["slots"]?.toString(),

    schedules: json["schedules"] == null
        ? []
        : List<Schedule>.from(
      json["schedules"].map((x) => Schedule.fromJson(x)),
    ),

    items: json["items"] == null
        ? []
        : List<Item>.from(
      json["items"].map((x) => Item.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "total_amount": totalAmount,
    "order_type": orderType,
    "is_paid": isPaid,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "delivery_dates": deliveryDates,
    "slot": slot,
    "schedules": schedules?.map((e) => e.toJson()).toList(),
    "items": items?.map((e) => e.toJson()).toList(),
  };
}
