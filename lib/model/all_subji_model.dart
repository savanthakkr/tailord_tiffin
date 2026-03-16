import 'dart:convert';

AllSubjiModel allSubjiModelFromJson(String str) => AllSubjiModel.fromJson(json.decode(str));

String allSubjiModelToJson(AllSubjiModel data) => json.encode(data.toJson());

class AllSubjiModel {
  String? status;
  String? msg;
  List<Subji>? data;

  AllSubjiModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AllSubjiModel.fromJson(Map<String, dynamic> json) => AllSubjiModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Subji>.from(json["data"]!.map((x) => Subji.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Subji {
  String? subjiId;
  String? name;
  String? price;
  DateTime? createdAt;

  Subji({
    this.subjiId,
    this.name,
    this.price,
    this.createdAt,
  });

  factory Subji.fromJson(Map<String, dynamic> json) => Subji(
    subjiId: json["subji_id"],
    name: json["name"],
    price: json["price"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "subji_id": subjiId,
    "name": name,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
  };
}
