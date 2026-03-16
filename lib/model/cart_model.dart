import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  String? status;
  String? msg;
  List<CartData>? data;

  CartModel({
    this.status,
    this.msg,
    this.data,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<CartData>.from(json["data"]!.map((x) => CartData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CartData {
  String? cartId;
  String? totalPrice;
  String? mealQuantity;
  DateTime? createdAt;
  Meal? meal;
  SelectedItems? selectedItems;
  List<ExtraItem>? extraItems;

  CartData({
    this.cartId,
    this.totalPrice,
    this.mealQuantity,
    this.createdAt,
    this.meal,
    this.selectedItems,
    this.extraItems,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    cartId: json["cart_id"],
    totalPrice: json["total_price"],
    mealQuantity: json["meal_quantity"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    meal: json["meal"] == null ? null : Meal.fromJson(json["meal"]),
    selectedItems: json["selected_items"] == null ? null : SelectedItems.fromJson(json["selected_items"]),
    extraItems: json["extra_items"] == null ? [] : List<ExtraItem>.from(json["extra_items"]!.map((x) => ExtraItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "total_price": totalPrice,
    "meal_quantity": mealQuantity,
    "created_at": createdAt?.toIso8601String(),
    "meal": meal?.toJson(),
    "selected_items": selectedItems?.toJson(),
    "extra_items": extraItems == null ? [] : List<dynamic>.from(extraItems!.map((x) => x.toJson())),
  };
}

class ExtraItem {
  String? item_id;
  String? item_type;
  String? name;
  String? price;
  String? quantity;
  String? subtotal;

  ExtraItem({
    this.item_id,
    this.item_type,
    this.name,
    this.price,
    this.quantity,
    this.subtotal,
  });

  factory ExtraItem.fromJson(Map<String, dynamic> json) => ExtraItem(
    item_id: json["item_id"],
    item_type: json["item_type"],
    name: json["name"],
    price: json["price"],
    quantity: json["quantity"],
    subtotal: json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": item_id,
    "item_type": item_type,
    "name": name,
    "price": price,
    "quantity": quantity,
    "subtotal": subtotal,
  };
}

class Meal {
  String? mealId;
  String? name;
  String? price;
  Structure? structure;

  Meal({
    this.mealId,
    this.name,
    this.price,
    this.structure,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    mealId: json["meal_id"],
    name: json["name"],
    price: json["price"],
    structure: json["structure"] == null ? null : Structure.fromJson(json["structure"]),
  );

  Map<String, dynamic> toJson() => {
    "meal_id": mealId,
    "name": name,
    "price": price,
    "structure": structure?.toJson(),
  };
}

class Structure {
  String? breadCount;
  String? subjiCount;
  String? otherCount;
  String? is_special_meal;

  Structure({
    this.breadCount,
    this.subjiCount,
    this.otherCount,
    this.is_special_meal,
  });

  factory Structure.fromJson(Map<String, dynamic> json) => Structure(
    breadCount: json["bread_count"],
    subjiCount: json["subji_count"],
    otherCount: json["other_count"],
    is_special_meal: json["is_special_meal"],
  );

  Map<String, dynamic> toJson() => {
    "bread_count": breadCount,
    "subji_count": subjiCount,
    "other_count": otherCount,
    "is_special_meal": is_special_meal,
  };
}

class SelectedItems {
  AllBread? bread;
  List<AllSubji>? subjis;
  SpecialMeal? specialMeal;

  SelectedItems({
    this.bread,
    this.subjis,
    this.specialMeal,
  });

  factory SelectedItems.fromJson(Map<String, dynamic> json) => SelectedItems(
    bread: json["bread"] == null ? null : AllBread.fromJson(json["bread"]),
    subjis: json["subjis"] == null ? [] : List<AllSubji>.from(json["subjis"]!.map((x) => AllSubji.fromJson(x))),
    specialMeal: json["special_item"] == null ? null : SpecialMeal.fromJson(json["special_item"]),
  );

  Map<String, dynamic> toJson() => {
    "bread": bread?.toJson(),
    "subjis": subjis == null ? [] : List<dynamic>.from(subjis!.map((x) => x.toJson())),
  };
}

class AllBread {
  String? breadId;
  String? name;
  String? price;

  AllBread({
    this.breadId,
    this.name,
    this.price,
  });

  factory AllBread.fromJson(Map<String, dynamic> json) => AllBread(
    breadId: json["bread_id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "bread_id": breadId,
    "name": name,
    "price": price,
  };
}

class SpecialMeal {
  String? special_item_id;
  String? name;
  String? price;

  SpecialMeal({
    this.special_item_id,
    this.name,
    this.price,
  });

  factory SpecialMeal.fromJson(Map<String, dynamic> json) => SpecialMeal(
    special_item_id: json["special_item_id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "special_item_id": special_item_id,
    "name": name,
    "price": price,
  };
}

class AllSubji {
  String? subjiId;
  String? name;
  String? price;

  AllSubji({
    this.subjiId,
    this.name,
    this.price,
  });

  factory AllSubji.fromJson(Map<String, dynamic> json) => AllSubji(
    subjiId: json["subji_id"],
    name: json["name"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "subji_id": subjiId,
    "name": name,
    "price": price,
  };
}
