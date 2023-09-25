// To parse this JSON data, do
//
//     final dealsDataModel = dealsDataModelFromJson(jsonString);

import 'dart:convert';

List<DealsDataModel> dealsDataModelFromJson(String str) => List<DealsDataModel>.from(json.decode(str).map((x) => DealsDataModel.fromJson(x)));

String dealsDataModelToJson(List<DealsDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DealsDataModel {
  int id;
  String name;
  String image;
  String type;
  dynamic subType;
  dynamic offerAvailableTimeStarts;
  dynamic offerAvailableTimeEnds;
  DateTime expireDate;
  dynamic offerDays;
  String totalDiscountAmount;
  double price;
  String discountPercentage;
  String restaurantId;
  String isParent;
  DateTime createdAt;
  DateTime updatedAt;
  List<DealItem> dealItems;

  DealsDataModel({
    this.id,
    this.name,
    this.image,
    this.type,
    this.subType,
    this.offerAvailableTimeStarts,
    this.offerAvailableTimeEnds,
    this.expireDate,
    this.offerDays,
    this.totalDiscountAmount,
    this.price,
    this.discountPercentage,
    this.restaurantId,
    this.isParent,
    this.createdAt,
    this.updatedAt,
    this.dealItems,
  });

  factory DealsDataModel.fromJson(Map<String, dynamic> json) => DealsDataModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
    subType: json["sub_type"],
    offerAvailableTimeStarts: json["offer_available_time_starts"],
    offerAvailableTimeEnds: json["offer_available_time_ends"],
    expireDate: DateTime.parse(json["expire_date"]),
    offerDays: json["offer_days"],
    totalDiscountAmount: json["total_discount_amount"],
    price: json["price"].toDouble(),
    discountPercentage: json["discount_percentage"],
    restaurantId: json["restaurant_id"],
    isParent: json["is_parent"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    dealItems: List<DealItem>.from(json["deal_items"].map((x) => DealItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "type": type,
    "sub_type": subType,
    "offer_available_time_starts": offerAvailableTimeStarts,
    "offer_available_time_ends": offerAvailableTimeEnds,
    "expire_date": "${expireDate.year.toString().padLeft(4, '0')}-${expireDate.month.toString().padLeft(2, '0')}-${expireDate.day.toString().padLeft(2, '0')}",
    "offer_days": offerDays,
    "total_discount_amount": totalDiscountAmount,
    "price": price,
    "discount_percentage": discountPercentage,
    "restaurant_id": restaurantId,
    "is_parent": isParent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deal_items": List<dynamic>.from(dealItems.map((x) => x.toJson())),
  };
}

class DealItem {
  int id;
  String name;
  String image;
  String itemPrice;
  String itemDiscountPrice;
  String itemQuantity;
  dynamic itemAvailableTimeStarts;
  dynamic itemsAvailableTimeEnds;
  dynamic days;
  String productId;
  String offerId;
  String restaurantId;
  DateTime updatedAt;
  DateTime createdAt;

  DealItem({
    this.id,
    this.name,
    this.image,
    this.itemPrice,
    this.itemDiscountPrice,
    this.itemQuantity,
    this.itemAvailableTimeStarts,
    this.itemsAvailableTimeEnds,
    this.days,
    this.productId,
    this.offerId,
    this.restaurantId,
    this.updatedAt,
    this.createdAt,
  });

  factory DealItem.fromJson(Map<String, dynamic> json) => DealItem(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    itemPrice: json["item_price"],
    itemDiscountPrice: json["item_discount_price"],
    itemQuantity: json["item_quantity"],
    itemAvailableTimeStarts: json["item_available_time_starts"],
    itemsAvailableTimeEnds: json["items_available_time_ends"],
    days: json["days"],
    productId: json["product_id"],
    offerId: json["offer_id"],
    restaurantId: json["restaurant_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "item_price": itemPrice,
    "item_discount_price": itemDiscountPrice,
    "item_quantity": itemQuantity,
    "item_available_time_starts": itemAvailableTimeStarts,
    "items_available_time_ends": itemsAvailableTimeEnds,
    "days": days,
    "product_id": productId,
    "offer_id": offerId,
    "restaurant_id": restaurantId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}
