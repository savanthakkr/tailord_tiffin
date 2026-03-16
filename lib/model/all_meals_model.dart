import 'dart:convert';

AllMealsModel allMealsModelFromJson(String str) => AllMealsModel.fromJson(json.decode(str));

String allMealsModelToJson(AllMealsModel data) => json.encode(data.toJson());

class AllMealsModel {
  String? status;
  String? msg;
  List<AllMeals>? data;

  AllMealsModel({
    this.status,
    this.msg,
    this.data,
  });

  factory AllMealsModel.fromJson(Map<String, dynamic> json) => AllMealsModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<AllMeals>.from(json["data"]!.map((x) => AllMeals.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllMeals {
  String? mealsId;
  String? mealsName;
  String? price;
  String? description;
  String? breadCount;
  String? subjiCount;
  String? otherCount;
  String? isSpecialMeal;
  String? image;
  dynamic specialItemId;
  DateTime? createdAt;
  SelectionRules? selectionRules;

  AllMeals({
    this.mealsId,
    this.mealsName,
    this.price,
    this.description,
    this.breadCount,
    this.subjiCount,
    this.otherCount,
    this.isSpecialMeal,
    this.image,
    this.specialItemId,
    this.createdAt,
    this.selectionRules,
  });

  factory AllMeals.fromJson(Map<String, dynamic> json) => AllMeals(
    mealsId: json["meals_id"],
    mealsName: json["meals_name"],
    price: json["price"],
    description: json["description"],
    breadCount: json["bread_count"],
    subjiCount: json["subji_count"],
    otherCount: json["other_count"],
    isSpecialMeal: json["is_special_meal"],
    image: json["image"],
    specialItemId: json["special_item_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    selectionRules: json["selection_rules"] == null ? null : SelectionRules.fromJson(json["selection_rules"]),
  );

  Map<String, dynamic> toJson() => {
    "meals_id": mealsId,
    "meals_name": mealsName,
    "price": price,
    "description": description,
    "bread_count": breadCount,
    "subji_count": subjiCount,
    "other_count": otherCount,
    "is_special_meal": isSpecialMeal,
    "image": image,
    "special_item_id": specialItemId,
    "created_at": createdAt?.toIso8601String(),
    "selection_rules": selectionRules?.toJson(),
  };
}

class SelectionRules {
  String? meal_type;
  String? allowSubji;
  String? subjiCount;
  String? allowBread;
  String? breadCount;
  String? allowOtherItems;
  String? otherCount;

  SelectionRules({
    this.meal_type,
    this.allowSubji,
    this.subjiCount,
    this.allowBread,
    this.breadCount,
    this.allowOtherItems,
    this.otherCount,
  });

  factory SelectionRules.fromJson(Map<String, dynamic> json) => SelectionRules(
    meal_type: json["meal_type"],
    allowSubji: json["allow_subji"],
    subjiCount: json["meal_type"] == "special" ? "1" : json["subji_count"],
    allowBread: json["allow_bread"],
    breadCount: json["bread_count"],
    allowOtherItems: json["allow_other_items"],
    otherCount: json["other_count"],
  );

  Map<String, dynamic> toJson() => {
    "allow_subji": allowSubji,
    "subji_count": subjiCount,
    "allow_bread": allowBread,
    "bread_count": breadCount,
    "allow_other_items": allowOtherItems,
    "other_count": otherCount,
  };
}
