import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  String? status;
  String? msg;
  ResponseData? data;

  ResponseModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    status: json["status"].toString(),
    msg: json["msg"],
    data: json["data"] == null ? null : ResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class ResponseData {
  String? addressId;

  ResponseData({
    this.addressId,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    addressId: json["address_id"],
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId,
  };
}
