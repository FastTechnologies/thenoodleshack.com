// To parse this JSON data, do
//
//     final specialOfferModel = specialOfferModelFromJson(jsonString);

import 'dart:convert';

List<SpecialOfferModel> specialOfferModelFromJson(String str) => List<SpecialOfferModel>.from(json.decode(str).map((x) => SpecialOfferModel.fromJson(x)));

String specialOfferModelToJson(List<SpecialOfferModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpecialOfferModel {
  int id;
  String name;
  String image;
  String type;
  String subType;
  String offerAvailableTimeStarts;
  String offerAvailableTimeEnds;
  dynamic offerDays;
  String totalDiscountAmount;
  int price;
  String restaurantId;
  String isParent;
  DateTime createdAt;
  DateTime updatedAt;
  List<OfferProduct> happyhour;
  List<SpecialOfferModel> catering;
  List<SpecialOfferModel> buffet;
  List<OfferProduct> allItems;
  OfferProduct offerProduct;

  SpecialOfferModel({
    this.id,
    this.name,
    this.image,
    this.type,
    this.subType,
    this.offerAvailableTimeStarts,
    this.offerAvailableTimeEnds,
    this.offerDays,
    this.totalDiscountAmount,
    this.price,
    this.restaurantId,
    this.isParent,
    this.createdAt,
    this.updatedAt,
    this.happyhour,
    this.catering,
    this.buffet,
    this.allItems,
    this.offerProduct,
  });

  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) => SpecialOfferModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
    subType: json["sub_type"],
    offerAvailableTimeStarts: json["offer_available_time_starts"],
    offerAvailableTimeEnds: json["offer_available_time_ends"],
    offerDays: json["offer_days"],
    totalDiscountAmount: json["total_discount_amount"],
    price: json["price"].toInt(),
    restaurantId: json["restaurant_id"],
    isParent: json["is_parent"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    happyhour:json["happyhour"]!=null? List<OfferProduct>.from(json["happyhour"].map((x) => OfferProduct.fromJson(x))):null,
    catering:json["catering"]!=null? List<SpecialOfferModel>.from(json["catering"].map((x) => SpecialOfferModel.fromJson(x))):null,
    buffet:json["buffet"]!=null? List<SpecialOfferModel>.from(json["buffet"].map((x) => SpecialOfferModel.fromJson(x))):null,
    allItems:json["all_items"]!=null? List<OfferProduct>.from(json["all_items"].map((x) => OfferProduct.fromJson(x))):null,
    offerProduct:json["tray_item"]!=null? OfferProduct.fromJson(json["tray_item"]):null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "type": type,
    "sub_type": subType,
    "offer_available_time_starts": offerAvailableTimeStarts,
    "offer_available_time_ends": offerAvailableTimeEnds,
    "offer_days": offerDays,
    "total_discount_amount": totalDiscountAmount,
    "price": price,
    "restaurant_id": restaurantId,
    "is_parent": isParent,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "happyhour": List<dynamic>.from(happyhour.map((x) => x.toJson())),
    "catering": List<dynamic>.from(catering.map((x) => x.toJson())),
    "buffet": List<dynamic>.from(buffet.map((x) => x.toJson())),
    "all_items": List<dynamic>.from(allItems.map((x) => x.toJson())),
    "tray_item": offerProduct.toJson(),
  };
}

class OfferProduct {
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

  OfferProduct({
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

  factory OfferProduct.fromJson(Map<String, dynamic> json) => OfferProduct(
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
