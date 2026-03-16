// To parse this JSON data, do
//
//     final addressRespModel = addressRespModelFromJson(jsonString);

import 'dart:convert';

AddressRespModel addressRespModelFromJson(String str) => AddressRespModel.fromJson(json.decode(str));

String addressRespModelToJson(AddressRespModel data) => json.encode(data.toJson());

class AddressRespModel {
  String? status;
  String? msg;
  Data? data;

  AddressRespModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AddressRespModel.fromJson(Map<String, dynamic> json) => AddressRespModel(
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
  String? addressId;

  Data({
    this.addressId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    addressId: json["address_id"],
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId,
  };
}
