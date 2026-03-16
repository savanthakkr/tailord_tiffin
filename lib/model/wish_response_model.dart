// To parse this JSON data, do
//
//     final wishResponseModel = wishResponseModelFromJson(jsonString);

import 'dart:convert';

WishResponseModel wishResponseModelFromJson(String str) => WishResponseModel.fromJson(json.decode(str));

String wishResponseModelToJson(WishResponseModel data) => json.encode(data.toJson());

class WishResponseModel {
  String? status;
  String? msg;
  Data? data;

  WishResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  factory WishResponseModel.fromJson(Map<String, dynamic> json) => WishResponseModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  String? wishlistId;

  Data({
    this.wishlistId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    wishlistId: json["wishlist_id"],
  );

  Map<String, dynamic> toJson() => {
    "wishlist_id": wishlistId,
  };
}
