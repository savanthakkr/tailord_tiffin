import 'dart:convert';

AddCartModel addCartModelFromJson(String str) => AddCartModel.fromJson(json.decode(str));

String addCartModelToJson(AddCartModel data) => json.encode(data.toJson());

class AddCartModel {
  String? status;
  String? msg;
  AddCart? data;

  AddCartModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AddCartModel.fromJson(Map<String, dynamic> json) => AddCartModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : AddCart.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class AddCart {
  String? cartId;
  String? totalPrice;

  AddCart({
    this.cartId,
    this.totalPrice,
  });

  factory AddCart.fromJson(Map<String, dynamic> json) => AddCart(
    cartId: json["cart_id"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "total_price": totalPrice,
  };
}
