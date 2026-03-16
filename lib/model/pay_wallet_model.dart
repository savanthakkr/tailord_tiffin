import 'dart:convert';

PayWalletModel payWalletModelFromJson(String str) => PayWalletModel.fromJson(json.decode(str));

String payWalletModelToJson(PayWalletModel data) => json.encode(data.toJson());

class PayWalletModel {
  String? status;
  String? msg;
  PayWallet? data;

  PayWalletModel({
    this.status,
    this.msg,
    this.data,
  });

  factory PayWalletModel.fromJson(Map<String, dynamic> json) => PayWalletModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : PayWallet.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class PayWallet {
  RazorpayWallet? razorpay;

  PayWallet({
    this.razorpay,
  });

  factory PayWallet.fromJson(Map<String, dynamic> json) => PayWallet(
    razorpay: json["razorpay"] == null ? null : RazorpayWallet.fromJson(json["razorpay"]),
  );

  Map<String, dynamic> toJson() => {
    "razorpay": razorpay?.toJson(),
  };
}

class RazorpayWallet {
  String? key;
  String? orderId;
  String? amount;
  String? currency;

  RazorpayWallet({
    this.key,
    this.orderId,
    this.amount,
    this.currency,
  });

  factory RazorpayWallet.fromJson(Map<String, dynamic> json) => RazorpayWallet(
    key: json["key"],
    orderId: json["order_id"],
    amount: json["amount"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "order_id": orderId,
    "amount": amount,
    "currency": currency,
  };
}
