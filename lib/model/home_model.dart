// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

import 'package:tailoredtiffin/model/product.dart';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  String? status;
  String? msg;
  Data? data;

  HomeModel({
    this.status,
    this.msg,
    this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  List<Product>? featuredProducts;
  List<Product>? bestSellingProducts;

  Data({
    this.featuredProducts,
    this.bestSellingProducts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    featuredProducts: json["featured_products"] == null ? [] : List<Product>.from(json["featured_products"]!.map((x) => Product.fromJson(x))),
    bestSellingProducts: json["best_selling_products"] == null ? [] : List<Product>.from(json["best_selling_products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "featured_products": featuredProducts == null ? [] : List<dynamic>.from(featuredProducts!.map((x) => x.toJson())),
    "best_selling_products": bestSellingProducts == null ? [] : List<dynamic>.from(bestSellingProducts!.map((x) => x.toJson())),
  };
}



class Attribute {
  String? attributeId;
  String? attributeName;
  List<String>? values;

  Attribute({
    this.attributeId,
    this.attributeName,
    this.values,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    attributeId: json["attribute_id"],
    attributeName: json["attribute_name"],
    values: json["values"] == null ? [] : List<String>.from(json["values"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "attribute_id": attributeId,
    "attribute_name": attributeName,
    "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
  };
}
