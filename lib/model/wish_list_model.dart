// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

WishListModel wishListModelFromJson(String str) => WishListModel.fromJson(json.decode(str));

String wishListModelToJson(WishListModel data) => json.encode(data.toJson());

class WishListModel {
  String? status;
  String? msg;
  Data? data;

  WishListModel({
    this.status,
    this.msg,
    this.data,
  });

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
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
  List<WishElement>? list;

  Data({
    this.list,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    list: json["list"] == null ? [] : List<WishElement>.from(json["list"]!.map((x) => WishElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class WishElement {
  String? wishlistId;
  String? productId;
  String? productName;
  String? productDescription;
  String? productSalePrice;
  String? productImage;

  WishElement({
    this.wishlistId,
    this.productId,
    this.productName,
    this.productDescription,
    this.productSalePrice,
    this.productImage,
  });

  factory WishElement.fromJson(Map<String, dynamic> json) => WishElement(
    wishlistId: json["wishlist_id"],
    productId: json["product_id"],
    productName: json["product_name"],
    productDescription: json["product_description"],
    productSalePrice: json["product_sale_price"],
    productImage: json["product_image"],
  );

  Map<String, dynamic> toJson() => {
    "wishlist_id": wishlistId,
    "product_id": productId,
    "product_name": productName,
    "product_description": productDescription,
    "product_sale_price": productSalePrice,
    "product_image": productImage,
  };
}
