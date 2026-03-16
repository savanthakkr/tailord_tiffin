import 'dart:convert';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String? status;
  String? msg;
  Register? data;

  RegisterModel({
    this.status,
    this.msg,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Register.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Register {
  String? userId;
  String? token;

  Register({
    this.userId,
    this.token,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    userId: json["user_id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "token": token,
  };
}
