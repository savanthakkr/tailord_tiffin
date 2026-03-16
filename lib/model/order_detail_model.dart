import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) => OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) => json.encode(data.toJson());

class OrderDetailModel {
  String? status;
  String? msg;
  OrderDetailsData? data;

  OrderDetailModel({
    this.status,
    this.msg,
    this.data,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : OrderDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class OrderDetailsData {
  Order? order;
  List<Schedule>? schedules;
  List<Item>? items;
  List<WalletTransaction>? walletTransactions;

  OrderDetailsData({
    this.order,
    this.schedules,
    this.items,
    this.walletTransactions,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) =>
      OrderDetailsData(
        order: json["order"] == null || json["order"] is List
            ? null
            : Order.fromJson(json["order"]),

        schedules: json["schedules"] == null
            ? []
            : List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),

        items: json["items"] == null
            ? []
            : List<Item>.from(
            json["items"].map((x) => Item.fromJson(x))),

        walletTransactions: json["wallet_transactions"] == null
            ? []
            : List<WalletTransaction>.from(
            json["wallet_transactions"]
                .map((x) => WalletTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "order": order?.toJson(),
    "schedules": schedules == null ? [] : List<dynamic>.from(schedules!.map((x) => x.toJson())),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "wallet_transactions": walletTransactions == null ? [] : List<dynamic>.from(walletTransactions!.map((x) => x.toJson())),
  };
}

class Item {
  String? orderItemId;
  String? quantity;
  String? price;
  Meal? meal;
  SelectedItems? selectedItems;
  List<ExtraItem>? extraItems;

  Item({
    this.orderItemId,
    this.quantity,
    this.price,
    this.meal,
    this.selectedItems,
    this.extraItems,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    orderItemId: json["order_item_id"]?.toString(),
    quantity: json["quantity"]?.toString(),
    price: json["price"]?.toString(),

    meal: json["meal"] != null
        ? Meal.fromJson(json["meal"])
        : Meal(
      name: json["meals_name"]?.toString(),
      breadCount: json["bread_count"]?.toString(),
      subjiCount: json["subji_count"]?.toString(),
    ),

    selectedItems: json["selected_items"] == null
        ? null
        : SelectedItems.fromJson(json["selected_items"]),

    extraItems: json["extra_items"] == null
        ? []
        : List<ExtraItem>.from(
      json["extra_items"].map((x) => ExtraItem.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "order_item_id": orderItemId,
    "quantity": quantity,
    "price": price,
    "meal": meal?.toJson(),
    "selected_items": selectedItems?.toJson(),
    "extra_items": extraItems == null ? [] : List<dynamic>.from(extraItems!.map((x) => x.toJson())),
  };
}

class ExtraItem {
  String? name;
  String? price;
  String? quantity;
  String? subtotal;

  ExtraItem({
    this.name,
    this.price,
    this.quantity,
    this.subtotal,
  });

  factory ExtraItem.fromJson(Map<String, dynamic> json) => ExtraItem(
    name: json["name"]?.toString(),
    price: json["price"]?.toString(),
    quantity: json["quantity"]?.toString(),
    subtotal: json["subtotal"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "quantity": quantity,
    "subtotal": subtotal,
  };
}

class Meal {
  String? name;
  String? breadCount;
  String? subjiCount;

  Meal({
    this.name,
    this.breadCount,
    this.subjiCount,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    name: json["name"]?.toString(),
    breadCount: json["bread_count"]?.toString(),
    subjiCount: json["subji_count"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "bread_count": breadCount,
    "subji_count": subjiCount,
  };
}

class SelectedItems {
  Bread? bread;
  List<Subji>? subjis;

  SelectedItems({
    this.bread,
    this.subjis,
  });

  factory SelectedItems.fromJson(Map<String, dynamic> json) => SelectedItems(
    bread: json["bread"] == null ? null : Bread.fromJson(json["bread"]),
    subjis: json["subjis"] == null ? [] : List<Subji>.from(json["subjis"]!.map((x) => Subji.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bread": bread?.toJson(),
    "subjis": subjis == null ? [] : List<dynamic>.from(subjis!.map((x) => x.toJson())),
  };
}

class Bread {
  String? breadId;
  String? name;
  String? price;

  Bread({
    this.breadId,
    this.name,
    this.price,
  });

  factory Bread.fromJson(Map<String, dynamic> json) => Bread(
    breadId: json["bread_id"]?.toString(),
    name: json["name"]?.toString(),
    price: json["price"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "bread_id": breadId,
    "name": name,
    "price": price,
  };
}

class Subji {
  String? subjiId;
  String? name;
  String? price;

  Subji({
    this.subjiId,
    this.name,
    this.price,
  });

  factory Subji.fromJson(Map<String, dynamic> json) => Subji(
    subjiId: json["subji_id"]?.toString(),
    name: json["name"]?.toString(),
    price: json["price"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "subji_id": subjiId,
    "name": name,
    "price": price,
  };
}

class Order {
  String? orderId;
  String? userId;
  String? orderType;
  String? status;
  String? totalAmount;
  String? isPaid;
  String? payment_type;
  dynamic paymentId;
  DateTime? createdAt;
  dynamic updatedAt;

  Order({
    this.orderId,
    this.userId,
    this.orderType,
    this.status,
    this.totalAmount,
    this.isPaid,
    this.payment_type,
    this.paymentId,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["order_id"]?.toString(),
    userId: json["user_id"]?.toString(),
    orderType: json["order_type"]?.toString(),
    status: json["status"]?.toString(),
    totalAmount: json["total_amount"]?.toString(),
    isPaid: json["is_paid"]?.toString(),
    payment_type: json["payment_type"]?.toString(),
    paymentId: json["payment_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "user_id": userId,
    "order_type": orderType,
    "status": status,
    "total_amount": totalAmount,
    "is_paid": isPaid,
    "payment_type": payment_type,
    "payment_id": paymentId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}

class Schedule {
  DateTime? deliveryDate;
  String? slot;
  String? status;
  String? delivery_status;
  String? payment_status;
  String? addressTitle;
  String? fullAddress;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? latitude;
  String? longitude;

  Schedule({
    this.deliveryDate,
    this.slot,
    this.status,
    this.delivery_status,
    this.payment_status,
    this.fullAddress,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    deliveryDate: json["delivery_date"] == null
        ? null
        : DateTime.parse(json["delivery_date"].toString()),
    slot: json["slot"]?.toString(),
    status: json["status"]?.toString(),
    delivery_status: json["delivery_status"]?.toString(),
    payment_status: json["payment_status"]?.toString(),
    fullAddress: json["full_address"]?.toString(),
    landmark: json["landmark"]?.toString(),
    city: json["city"]?.toString(),
    state: json["state"]?.toString(),
    pincode: json["pincode"]?.toString(),
    latitude: json["latitude"]?.toString(),
    longitude: json["longitude"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "delivery_date": "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
    "slot": slot,
    "status": status,
    "delivery_status": delivery_status,
    "payment_status": payment_status,
    "full_address": fullAddress,
    "landmark": landmark,
    "city": city,
    "state": state,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,

  };
}

class WalletTransaction {
  String? type;
  String? amount;
  String? description;
  DateTime? createdAt;

  WalletTransaction({
    this.type,
    this.amount,
    this.description,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
    type: json["type"]?.toString(),
    amount: json["amount"]?.toString(),
    description: json["description"]?.toString(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
  };
}
