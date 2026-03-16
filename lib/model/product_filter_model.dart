import 'dart:convert';

import 'package:tailoredtiffin/model/product.dart';

ProductFilterModel productFilterModelFromJson(String str) => ProductFilterModel.fromJson(json.decode(str));

String productFilterModelToJson(ProductFilterModel data) => json.encode(data.toJson());

class ProductFilterModel {
  String? status;
  String? msg;
  List<Product>? data;

  ProductFilterModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ProductFilterModel.fromJson(Map<String, dynamic> json) => ProductFilterModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}