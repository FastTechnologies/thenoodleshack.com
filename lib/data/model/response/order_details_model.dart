import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'dart:convert';

import 'offer_model.dart';
import 'order_model.dart';

List<OrderDetailsModel> orderDetailsModelFromJson(String str) => List<OrderDetailsModel>.from(json.decode(str).map((x) => OrderDetailsModel.fromJson(x)));

String orderDetailsModelToJson(List<OrderDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDetailsModel {
  int id;
  int productId;
  int orderId;
  double price;
  Product productDetails;
  dynamic variation;
  int discountOnProduct;
  String discountType;
  String loyaltyPoints;
  int quantity;
  int taxAmount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic addOnIds;
  List<dynamic> variant;
  dynamic addOnQtys;
  String restaurantId;
  dynamic happyHourId;
  String cateringId;
  SpecialOfferModel offerDetail;
  String reviewsCount;
  int isProductAvailable;
  OrderModel order;

  OrderDetailsModel({
    this.id,
    this.productId,
    this.orderId,
    this.price,
    this.productDetails,
    this.variation,
    this.discountOnProduct,
    this.discountType,
    this.quantity,
    this.taxAmount,
    this.createdAt,
    this.updatedAt,
    this.addOnIds,
    this.variant,
    this.addOnQtys,
    this.restaurantId,
    this.happyHourId,
    this.cateringId,
    this.offerDetail,
    this.reviewsCount,
    this.isProductAvailable,
    this.order,
    this.loyaltyPoints,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    id: json["id"],
    productId: json["product_id"],
    orderId: json["order_id"],
    price: json["price"].toDouble(),
    productDetails:json["product_details"]==null?null: Product.fromJson(json["product_details"]),
    variation: json["variation"],
    discountOnProduct: json["discount_on_product"],
    discountType: json["discount_type"],
    quantity: json["quantity"],
    taxAmount: json["tax_amount"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    addOnIds: json["add_on_ids"],

    //variant:json["variant"]==null?null: List<dynamic>.from(json["variant"].map((x) => x)),
    addOnQtys: json["add_on_qtys"],
    restaurantId: json["restaurant_id"],
    happyHourId: json["happy_hour_id"],
    cateringId: json["catering_id"],
    offerDetail:json["offer_detail"]==null?null: SpecialOfferModel.fromJson(json["offer_detail"]),
    reviewsCount: json["reviews_count"],
    isProductAvailable: json["is_product_available"],
    loyaltyPoints: json["loyalty_points"],
    order: OrderModel.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "order_id": orderId,
    "price": price,
    "product_details": productDetails.toJson(),
    "variation": variation,
    "discount_on_product": discountOnProduct,
    "discount_type": discountType,
    "quantity": quantity,
    "tax_amount": taxAmount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "add_on_ids": addOnIds,
    "variant": List<dynamic>.from(variant.map((x) => x)),
    "add_on_qtys": addOnQtys,
    "restaurant_id": restaurantId,
    "happy_hour_id": happyHourId,
    "catering_id": cateringId,
    "offer_detail": offerDetail.toJson(),
    "reviews_count": reviewsCount,
    "is_product_available": isProductAvailable,
    "loyalty_points": loyaltyPoints,
    "order": order.toJson(),
  };
}




// class OrderDetailsModel {
//   int _id;
//   int _productId;
//   int _orderId;
//   double _price;
//   Product _productDetails;
//   List<Variation> _variations;
//   Variation _variation;
//   double _discountOnProduct;
//   String _discountType;
//   int _quantity;
//   double _taxAmount;
//   String _createdAt;
//   String _updatedAt;
//   List<int> _addOnIds;
//   List<int> _addOnQtys;
//
//   OrderDetailsModel(
//       {int id,
//         int productId,
//         int orderId,
//         double price,
//         Product productDetails,
//         List<Variation> variations,
//         Variation variation,
//         double discountOnProduct,
//         String discountType,
//         int quantity,
//         double taxAmount,
//         String createdAt,
//         String updatedAt,
//         List<int> addOnIds,
//         List<int> addOnQtys,
//       }) {
//     this._id = id;
//     this._productId = productId;
//     this._orderId = orderId;
//     this._price = price;
//     this._productDetails = productDetails;
//     this._variation = variation;
//     this._variations = variations;
//     this._discountOnProduct = discountOnProduct;
//     this._discountType = discountType;
//     this._quantity = quantity;
//     this._taxAmount = taxAmount;
//     this._createdAt = createdAt;
//     this._updatedAt = updatedAt;
//     this._addOnIds = addOnIds;
//     this._addOnQtys = addOnQtys;
//   }
//
//   int get id => _id;
//   int get productId => _productId;
//   int get orderId => _orderId;
//   double get price => _price;
//   Product get productDetails => _productDetails;
//   List<Variation> get variations => _variations;
//   Variation get variation => _variation;
//   double get discountOnProduct => _discountOnProduct;
//   String get discountType => _discountType;
//   int get quantity => _quantity;
//   double get taxAmount => _taxAmount;
//   String get createdAt => _createdAt;
//   String get updatedAt => _updatedAt;
//   List<int> get addOnIds => _addOnIds;
//   List<int> get addOnQtys => _addOnQtys;
//
//   OrderDetailsModel.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _productId = json['product_id'];
//     _orderId = json['order_id'];
//     _price = json['price'].toDouble();
//     try{
//       _productDetails = Product.fromJson(json['product_details']);
//     }catch(error) {
//       _productDetails = null;
//     }
//     if(json['variation'] != null) {
//       _variation = Variation.fromJson(json['variation']);
//     }
//
//     if (json['variations'] != null) {
//       _variations = [];
//       json['variations'].forEach((v) {
//         _variations.add(new Variation.fromJson(v));
//       });
//     }
//
//     _discountOnProduct = json['discount_on_product'].toDouble();
//     _discountType = json['discount_type'];
//     _quantity = json['quantity'];
//     _taxAmount = json['tax_amount'].toDouble();
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _addOnIds = json['add_on_ids'].cast<int>();
//     if(json['add_on_qtys'] != null) {
//       _addOnQtys = [];
//       json['add_on_qtys'].forEach((qun) {
//         try {
//           _addOnQtys.add( int.parse(qun));
//         }catch(e) {
//           _addOnQtys.add(qun);
//         }
//
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['product_id'] = this._productId;
//     data['order_id'] = this._orderId;
//     data['price'] = this._price;
//     data['variation'] = this.variation;
//     data['discount_on_product'] = this._discountOnProduct;
//     data['discount_type'] = this._discountType;
//     data['quantity'] = this._quantity;
//     data['tax_amount'] = this._taxAmount;
//     data['created_at'] = this._createdAt;
//     data['updated_at'] = this._updatedAt;
//     data['add_on_ids'] = this._addOnIds;
//     data['add_on_qtys'] = this._addOnQtys;
//     return data;
//   }
// }