import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

import '../response/offer_model.dart';

class PlaceOrderBody {
  List<Cart> _cart;
  List<SpecialOfferModel> _catering;
  List<OfferProduct> _happyHours;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  int _deliveryAddressId;
  String _paymentMethod;
  String _paymentId;
  String _orderNote;
  String _couponCode;
  String _deliveryTime;
  String _deliveryDate;
  int _branchId;
  double _distance;
  double _orderTip ;
  double _taxFee ;
  String _transactionReference;

  PlaceOrderBody copyWith({String paymentMethod, String transactionReference}) {
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody(
      {
        @required List<Cart> cart,
        @required List<SpecialOfferModel> catering,
        @required  List<OfferProduct> happyHours,
        @required double couponDiscountAmount,
        @required String couponDiscountTitle,
        @required String couponCode,
        @required double orderAmount,
        @required int deliveryAddressId,
        @required String orderType,
        @required String paymentMethod,
        @required int branchId,
        @required String deliveryTime,
        @required String deliveryDate,
        @required String orderNote,
        @required double distance,
         double orderTip,
         double taxFee,
        @required String paymentId,
        String transactionReference,
      }) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._deliveryAddressId = deliveryAddressId;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._deliveryTime = deliveryTime;
    this._deliveryDate = deliveryDate;
    this._branchId = branchId;
    this._distance = distance;
    this._orderTip = orderTip;
    this._taxFee = taxFee;
    this._paymentId=paymentId;
    this._catering=catering;
    this._happyHours=happyHours;

    this._transactionReference = transactionReference;
  }

  List<Cart> get cart => _cart;
  List<OfferProduct> get happyOffers => _happyHours;
  List<SpecialOfferModel> get catering => _catering;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  int get deliveryAddressId => _deliveryAddressId;
  String get paymentMethod => _paymentMethod;
  String get paymentId => _paymentId;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  String get deliveryTime => _deliveryTime;
  String get deliveryDate => _deliveryDate;
  int get branchId => _branchId;
  double get distance => _distance;
  double get orderTip => _orderTip;
  double get taxFee => _taxFee;
  String get transactionReference => _transactionReference;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    if (json['catering'] != null) {
      _cart = [];
      json['catering'].forEach((v) {
        _catering.add(new SpecialOfferModel.fromJson(v));
      });
    }
    if (json['happy_hours'] != null) {
      _cart = [];
      json['happy_hours'].forEach((v) {
        _catering.add(new SpecialOfferModel.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _deliveryAddressId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _paymentId = json['payment_id'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _branchId = json['branch_id'];
    _distance = json['distance'];
    _orderTip = json['order_tip_amount'];
    _taxFee = json['total_tax_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._catering != null) {
      data['catering'] = this._catering.map((v) => v.toJson()).toList();
    }
    if (this._happyHours != null) {
      data['happy_hours'] = this._happyHours.map((v) => v.toJson()).toList();
    }
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['payment_method'] = this._paymentMethod;
    data['payment_id'] = this._paymentId;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['branch_id'] = this._branchId;
    data['distance'] = this._distance;
    data['order_tip_amount'] = this._orderTip;
    data['total_tax_amount'] = this._taxFee;
    if(_transactionReference != null) {
      data['transaction_reference'] = this._transactionReference;
    }
    return data;
  }
}

class Cart {
  String _productId;
  String _cateringId;
  String _happyHoursId;
  String _dealId;
  String _price;
  String _variant;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<int> _addOnIds;
  List<int> _addOnQtys;

  Cart(
      String productId,
        String price,
  String cateringId,
  String happyHoursId,
  String dealId,
        String variant,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        List<int> addOnIds,
        List<int> addOnQtys) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._dealId=dealId;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
    this._cateringId=cateringId;
    this._happyHoursId=happyHoursId;
  }

  String get productId => _productId;
  String get cateringId => _cateringId;
  String get happyHoursId => _happyHoursId;
  String get dealId => _dealId;
  String get price => _price;
  String get variant => _variant;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _cateringId = json['catering_id'];
    _happyHoursId = json['happy_hour_id'];
    _dealId = json['deal_id'];

    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['catering_id'] = this._cateringId;
    data['happy_hour_id'] = this._happyHoursId;
    data['deal_id'] = this._dealId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}
