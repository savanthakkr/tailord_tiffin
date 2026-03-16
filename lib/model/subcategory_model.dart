import 'dart:convert';

SubcategoryModel subcategoryModelFromJson(String str) => SubcategoryModel.fromJson(json.decode(str));

String subcategoryModelToJson(SubcategoryModel data) => json.encode(data.toJson());

class SubcategoryModel {
  String? status;
  String? msg;
  List<Subcategory>? data;

  SubcategoryModel({
    this.status,
    this.msg,
    this.data,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<Subcategory>.from(json["data"]!.map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Subcategory {
  String? subCategoryId;
  String? subCategoryName;
  String? subCategorySlug;
  String? categoryId;
  String? categoryName;

  Subcategory({
    this.subCategoryId,
    this.subCategoryName,
    this.subCategorySlug,
    this.categoryId,
    this.categoryName,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    subCategoryId: json["sub_category_id"],
    subCategoryName: json["sub_Category_Name"],
    subCategorySlug: json["sub_Category_Slug"],
    categoryId: json["category_Id"] != null ? json["category_Id"] : "",
    categoryName: json["category_Name"] != null ? json["category_Name"] : "",
  );

  Map<String, dynamic> toJson() => {
    "sub_category_id": subCategoryId,
    "sub_Category_Name": subCategoryName,
    "sub_Category_Slug": subCategorySlug,
    "category_Id": categoryId,
    "category_Name": categoryName,
  };
}
