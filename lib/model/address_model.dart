import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String? status;
  String? msg;
  List<Address>? data;

  AddressModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Address>.from(json["data"]!.map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Address {
  String? addressId;
  String? addressTitle;
  String? fullAddress;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? latitude;
  String? longitude;
  String? isDefault;
  DateTime? createdAt;

  Address({
    this.addressId,
    this.addressTitle,
    this.fullAddress,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressId: json["address_id"],
    addressTitle: json["address_title"],
    fullAddress: json["full_address"],
    landmark: json["landmark"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId,
    "address_title": addressTitle,
    "full_address": fullAddress,
    "landmark": landmark,
    "city": city,
    "state": state,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "is_default": isDefault,
    "created_at": createdAt?.toIso8601String(),
  };
}
