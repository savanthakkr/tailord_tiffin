import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? status;
  String? msg;
  Login? data;

  LoginModel({
    this.status,
    this.msg,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Login.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Login {
  User? user;
  String? token;

  Login({
    this.user,
    this.token,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  dynamic userId;
  String? name;
  String? mobileNo;
  String? email;

  String? isDeliveryBoy;
  DeliveryBoyDetails? deliveryBoyDetails;

  User({
    this.userId,
    this.name,
    this.mobileNo,
    this.email,
    this.isDeliveryBoy,
    this.deliveryBoyDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"] != "undefined" ? json["user_id"] : "" ,
    name: json["name"] != "undefined" ? json["name"] : "",
    mobileNo: json["mobile_no"] != "undefined" ? json["mobile_no"] : "",
    email: json["email"] != "undefined" ? json["email"] : "",
    isDeliveryBoy: json["is_delivery_boy"],
    deliveryBoyDetails: json["delivery_boy_details"] == null
        ? null
        : DeliveryBoyDetails.fromJson(json["delivery_boy_details"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "mobile_no": mobileNo,
    "email": email,
    "is_delivery_boy": isDeliveryBoy,
    "delivery_boy_details": deliveryBoyDetails?.toJson(),
  };
}class DeliveryBoyDetails {
  String? deliveryBoyId;
  String? firstName;
  String? mobileNo;

  DeliveryBoyDetails({
    this.deliveryBoyId,
    this.firstName,
    this.mobileNo,
  });

  factory DeliveryBoyDetails.fromJson(Map<String, dynamic> json) =>
      DeliveryBoyDetails(
        deliveryBoyId: json["delivery_boy_id"],
        firstName: json["first_name"],
        mobileNo: json["mobile_no"],
      );

  Map<String, dynamic> toJson() => {
    "delivery_boy_id": deliveryBoyId,
    "first_name": firstName,
    "mobile_no": mobileNo,
  };
}
