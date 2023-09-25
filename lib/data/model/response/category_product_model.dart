// To parse this JSON data, do
//
//     final categoryProductModel = categoryProductModelFromJson(jsonString);

import 'dart:convert';

import 'product_model.dart';

List<CategoryProductModel> categoryProductModelFromJson(String str) => List<CategoryProductModel>.from(json.decode(str).map((x) => CategoryProductModel.fromJson(x)));

String categoryProductModelToJson(List<CategoryProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryProductModel {
  CategoryProductModel({
    this.id,
    this.name,
    this.parentId,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.bannerImage,
    this.restaurantId,
    this.products,
    this.translations,
  });

  int id;
  String name;
  int parentId;
  int position;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String bannerImage;
  String restaurantId;
  List<Product> products;
  List<dynamic> translations;

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) => CategoryProductModel(
    id: json["id"],
    name: json["name"],
    parentId: json["parent_id"],
    position: json["position"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    image: json["image"],
    bannerImage: json["banner_image"],
    restaurantId: json["restaurant_id"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    translations: List<dynamic>.from(json["translations"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "parent_id": parentId,
    "position": position,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image": image,
    "banner_image": bannerImage,
    "restaurant_id": restaurantId,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "translations": List<dynamic>.from(translations.map((x) => x)),
  };
}

// class Product {
//   Product({
//     this.id,
//     this.name,
//     this.description,
//     this.image,
//     this.price,
//     this.variations,
//     this.addOns,
//     this.tax,
//     this.availableTimeStarts,
//     this.availableTimeEnds,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.attributes,
//     this.categoryIds,
//     this.choiceOptions,
//     this.discount,
//     this.discountType,
//     this.taxType,
//     this.setMenu,
//     this.branchId,
//     this.colors,
//     this.popularityCount,
//     this.productType,
//     this.restaurantId,
//     this.rating,
//   });
//
//   int id;
//   String name;
//   String description;
//   String image;
//   double price;
//   List<Variation> variations;
//   List<AddOn> addOns;
//   int tax;
//   String availableTimeStarts;
//   String availableTimeEnds;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<String> attributes;
//   List<CategoryId> categoryIds;
//   List<ChoiceOption> choiceOptions;
//   int discount;
//   String discountType;
//   String taxType;
//   int setMenu;
//   String branchId;
//   dynamic colors;
//   String popularityCount;
//   String productType;
//   String restaurantId;
//   List<Rating> rating;
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     name: json["name"],
//     description: json["description"],
//     image: json["image"],
//     price: json["price"].toDouble(),
//     variations: List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
//     addOns: List<AddOn>.from(json["add_ons"].map((x) => AddOn.fromJson(x))),
//     tax: json["tax"],
//     availableTimeStarts: json["available_time_starts"],
//     availableTimeEnds: json["available_time_ends"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     attributes: List<String>.from(json["attributes"].map((x) => x)),
//     categoryIds: List<CategoryId>.from(json["category_ids"].map((x) => CategoryId.fromJson(x))),
//     choiceOptions: List<ChoiceOption>.from(json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
//     discount: json["discount"],
//     discountType: json["discount_type"],
//     taxType: json["tax_type"],
//     setMenu: json["set_menu"],
//     branchId: json["branch_id"],
//     colors: json["colors"],
//     popularityCount: json["popularity_count"],
//     productType: json["product_type"],
//     restaurantId: json["restaurant_id"],
//     rating: List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "description": description,
//     "image": image,
//     "price": price,
//     "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
//     "add_ons": List<dynamic>.from(addOns.map((x) => x.toJson())),
//     "tax": tax,
//     "available_time_starts": availableTimeStarts,
//     "available_time_ends": availableTimeEnds,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "attributes": List<dynamic>.from(attributes.map((x) => x)),
//     "category_ids": List<dynamic>.from(categoryIds.map((x) => x.toJson())),
//     "choice_options": List<dynamic>.from(choiceOptions.map((x) => x.toJson())),
//     "discount": discount,
//     "discount_type": discountType,
//     "tax_type": taxType,
//     "set_menu": setMenu,
//     "branch_id": branchId,
//     "colors": colors,
//     "popularity_count": popularityCount,
//     "product_type": productType,
//     "restaurant_id": restaurantId,
//     "rating": List<dynamic>.from(rating.map((x) => x.toJson())),
//   };
// }
//
// class AddOn {
//   AddOn({
//     this.id,
//     this.name,
//     this.price,
//     this.restaurantId,
//     this.createdAt,
//     this.updatedAt,
//     this.translations,
//   });
//
//   int id;
//   String name;
//   int price;
//   String restaurantId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   List<dynamic> translations;
//
//   factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
//     id: json["id"],
//     name: json["name"],
//     price: json["price"],
//     restaurantId: json["restaurant_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     translations: List<dynamic>.from(json["translations"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "price": price,
//     "restaurant_id": restaurantId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "translations": List<dynamic>.from(translations.map((x) => x)),
//   };
// }
//
// class CategoryId {
//   CategoryId({
//     this.id,
//     this.position,
//   });
//
//   String id;
//   int position;
//
//   factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
//     id: json["id"],
//     position: json["position"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "position": position,
//   };
// }
//
// class ChoiceOption {
//   ChoiceOption({
//     this.name,
//     this.title,
//     this.options,
//   });
//
//   String name;
//   String title;
//   List<String> options;
//
//   factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
//     name: json["name"],
//     title: json["title"],
//     options: List<String>.from(json["options"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "title": title,
//     "options": List<dynamic>.from(options.map((x) => x)),
//   };
// }
//
// class Rating {
//   Rating({
//     this.average,
//     this.productId,
//   });
//
//   String average;
//   int productId;
//
//   factory Rating.fromJson(Map<String, dynamic> json) => Rating(
//     average: json["average"],
//     productId: json["product_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "average": average,
//     "product_id": productId,
//   };
// }
//
// class Variation {
//   Variation({
//     this.type,
//     this.price,
//   });
//
//   String type;
//   double price;
//
//   factory Variation.fromJson(Map<String, dynamic> json) => Variation(
//     type: json["type"],
//     price: json["price"].toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "type": type,
//     "price": price,
//   };
// }
