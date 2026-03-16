import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String? status;
  String? msg;
  Data? data;

  ProfileModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  User? user;
  Wallet? wallet;
  List<Address>? address;
  DeliveryBoyInfo? deliveryBoyInfo;

  Data({
    this.user,
    this.wallet,
    this.address,
    this.deliveryBoyInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    List<Address> parsedAddresses = [];

    if (json["address"] != null) {
      if (json["address"] is List) {
        parsedAddresses = (json["address"] as List)
            .map((e) => Address.fromJson(e))
            .toList();
      } else if (json["address"] is Map) {
        parsedAddresses = [
          Address.fromJson(json["address"])
        ];
      }
    }

    return Data(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
      address: parsedAddresses,
      deliveryBoyInfo: json["delivery_boy_info"] == null
          ? null
          : DeliveryBoyInfo.fromJson(json["delivery_boy_info"]),
    );
  }


  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "wallet": wallet?.toJson(),
    "address": address?.map((x) => x.toJson()).toList(),
    "delivery_boy_info": deliveryBoyInfo?.toJson(),
  };
}
class DeliveryBoyInfo {
  String? deliveryBoyId;
  String? firstName;
  String? lastName;
  String? mobileNo;
  String? isActive;

  DeliveryBoyInfo({
    this.deliveryBoyId,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.isActive,
  });

  factory DeliveryBoyInfo.fromJson(Map<String, dynamic> json) =>
      DeliveryBoyInfo(
        deliveryBoyId: json["delivery_boy_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobileNo: json["mobile_no"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
    "delivery_boy_id": deliveryBoyId,
    "first_name": firstName,
    "last_name": lastName,
    "mobile_no": mobileNo,
    "is_active": isActive,
  };
}


class Address {
  String? addressId;
  String? fullAddress;
  String? city;
  String? pincode;

  Address({
    this.addressId,
    this.fullAddress,
    this.city,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressId: json["address_id"],
    fullAddress: json["full_address"],
    city: json["city"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId,
    "full_address": fullAddress,
    "city": city,
    "pincode": pincode,
  };
}

class User {
  String? userId;
  String? name;
  String? email;
  String? mobileNo;
  String? isActive;
  String? allow_pay_later;
  DateTime? createdAt;

  User({
    this.userId,
    this.name,
    this.email,
    this.mobileNo,
    this.isActive,
    this.allow_pay_later,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    isActive: json["is_active"],
    allow_pay_later: json["allow_pay_later"] != null ? json["allow_pay_later"] : "",
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "is_active": isActive,
    "allow_pay_later": allow_pay_later,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Wallet {
  String? balance;

  Wallet({
    this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
  };
}
