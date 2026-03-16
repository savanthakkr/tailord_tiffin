// To parse this JSON data, do
//
//     final cartTotalModel = cartTotalModelFromJson(jsonString);

import 'dart:convert';

CartTotalModel cartTotalModelFromJson(String str) => CartTotalModel.fromJson(json.decode(str));

String cartTotalModelToJson(CartTotalModel data) => json.encode(data.toJson());

class CartTotalModel {
  String? status;
  String? msg;
  Data? data;

  CartTotalModel({
    this.status,
    this.msg,
    this.data,
  });

  factory CartTotalModel.fromJson(Map<String, dynamic> json) => CartTotalModel(
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
  String? originalTotal;
  String? totalOfferDiscount;
  String? finalPayable;
  List<Item>? items;

  Data({
    this.originalTotal,
    this.totalOfferDiscount,
    this.finalPayable,
    this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    originalTotal: json["original_total"],
    totalOfferDiscount: json["total_offer_discount"],
    finalPayable: json["final_payable"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "original_total": originalTotal,
    "total_offer_discount": totalOfferDiscount,
    "final_payable": finalPayable,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  String? cartId;
  String? productQuantity;
  String? productId;
  String? productSalePrice;
  String? productName;
  String? productImage;
  dynamic offerDiscount;
  dynamic offerType;

  Item({
    this.cartId,
    this.productQuantity,
    this.productId,
    this.productSalePrice,
    this.productName,
    this.productImage,
    this.offerDiscount,
    this.offerType,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    cartId: json["cart_id"],
    productQuantity: json["product_Quantity"],
    productId: json["product_id"],
    productSalePrice: json["product_sale_price"],
    productName: json["product_name"],
    productImage: json["product_image"],
    offerDiscount: json["offer_Discount"],
    offerType: json["offer_Type"],
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "product_Quantity": productQuantity,
    "product_id": productId,
    "product_sale_price": productSalePrice,
    "product_name": productName,
    "product_image": productImage,
    "offer_Discount": offerDiscount,
    "offer_Type": offerType,
  };
}
