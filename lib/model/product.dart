import 'home_model.dart';

class Product {
  String? productId;
  String? productName;
  String? productSlug;
  String? productDescription;
  String? productBasePrice;
  String? productSalePrice;
  String? productTags;
  String? productReview;
  DateTime? createdAt;
  String? categoryName;
  String? subCategoryName;
  String? totalSold;
  List<String>? images;
  List<Attribute>? attributes;

  Product({
    this.productId,
    this.productName,
    this.productSlug,
    this.productDescription,
    this.productBasePrice,
    this.productSalePrice,
    this.productTags,
    this.productReview,
    this.createdAt,
    this.categoryName,
    this.subCategoryName,
    this.totalSold,
    this.images,
    this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    productName: json["product_name"],
    productSlug: json["product_slug"],
    productDescription: json["product_description"],
    productBasePrice: json["product_base_price"],
    productSalePrice: json["product_sale_price"],
    productTags: json["product_tags"],
    productReview: json["product_review"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    categoryName: json["category_Name"],
    subCategoryName: json["sub_Category_Name"],
    totalSold: json["total_sold"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "product_slug": productSlug,
    "product_description": productDescription,
    "product_base_price": productBasePrice,
    "product_sale_price": productSalePrice,
    "product_tags": productTags,
    "product_review": productReview,
    "created_at": createdAt?.toIso8601String(),
    "category_Name": categoryName,
    "sub_Category_Name": subCategoryName,
    "total_sold": totalSold,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x.toJson())),
  };
}