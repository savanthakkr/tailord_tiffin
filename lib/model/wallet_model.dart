import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  String? status;
  String? msg;
  Wallet? data;

  WalletModel({
    this.status,
    this.msg,
    this.data,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Wallet.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Wallet {
  String? balance;
  List<Transaction>? transactions;

  Wallet({
    this.balance,
    this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    balance: json["balance"],
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Transaction {
  String? walletTxnId;
  String? userId;
  String? orderId;
  String? type;
  String? amount;
  String? description;
  DateTime? createdAt;

  Transaction({
    this.walletTxnId,
    this.userId,
    this.orderId,
    this.type,
    this.amount,
    this.description,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    walletTxnId: json["wallet_txn_id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    type: json["type"],
    amount: json["amount"],
    description: json["description"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "wallet_txn_id": walletTxnId,
    "user_id": userId,
    "order_id": orderId,
    "type": type,
    "amount": amount,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
  };
}
