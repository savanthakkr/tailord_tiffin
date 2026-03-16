// To parse this JSON data, do
//
//     final specialItemModel = specialItemModelFromJson(jsonString);

import 'dart:convert';

SpecialItemModel specialItemModelFromJson(String str) => SpecialItemModel.fromJson(json.decode(str));

String specialItemModelToJson(SpecialItemModel data) => json.encode(data.toJson());

class SpecialItemModel {
  String? status;
  String? msg;
  List<SpecialItem>? data;

  SpecialItemModel({
    this.status,
    this.msg,
    this.data,
  });

  factory SpecialItemModel.fromJson(Map<String, dynamic> json) => SpecialItemModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<SpecialItem>.from(json["data"]!.map((x) => SpecialItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SpecialItem {
  String? specialItemId;
  String? name;
  String? price;

  SpecialItem({
    this.specialItemId,
    this.name,
    this.price,
  });

  factory SpecialItem.fromJson(Map<String, dynamic> json) => SpecialItem(
    specialItemId: json["special_item_id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "special_item_id": specialItemId,
    "name": name,
    "price": price,
  };
}
