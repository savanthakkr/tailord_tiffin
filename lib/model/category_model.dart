import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String? status;
  String? msg;
  List<AllCategory>? data;

  CategoryModel({
    this.status,
    this.msg,
    this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<AllCategory>.from(json["data"]!.map((x) => AllCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllCategory {
  String? categoryId;
  String? categoryName;
  String? categorySlug;
  DateTime? createdAt;

  AllCategory({
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.createdAt,
  });

  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
    categoryId: json["category_id"],
    categoryName: json["category_Name"],
    categorySlug: json["category_Slug"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_Name": categoryName,
    "category_Slug": categorySlug,
    "created_at": createdAt?.toIso8601String(),
  };
}
