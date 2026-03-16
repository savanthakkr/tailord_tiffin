import 'dart:convert';

AllBreadModel allBreadModelFromJson(String str) => AllBreadModel.fromJson(json.decode(str));

String allBreadModelToJson(AllBreadModel data) => json.encode(data.toJson());

class AllBreadModel {
  String? status;
  String? msg;
  List<Bread>? data;

  AllBreadModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AllBreadModel.fromJson(Map<String, dynamic> json) => AllBreadModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Bread>.from(json["data"]!.map((x) => Bread.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Bread {
  String? breadId;
  String? name;
  String? price;
  DateTime? createdAt;

  Bread({
    this.breadId,
    this.name,
    this.price,
    this.createdAt,
  });

  factory Bread.fromJson(Map<String, dynamic> json) => Bread(
    breadId: json["bread_id"],
    name: json["name"],
    price: json["price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "bread_id": breadId,
    "name": name,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
  };
}
