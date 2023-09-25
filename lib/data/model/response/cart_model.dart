import 'package:flutter_restaurant/data/model/response/deals_data_model.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _points = 0.0;
  double _discountedPrice;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<AddOn> _addOnIds;
  Product _product;

  bool _isGift;
  bool _isFree = false;

  CartModel(
    double price,
    double points,
    double discountedPrice,
    List<Variation> variation,
    double discountAmount,
    int quantity,
    double taxAmount,
    List<AddOn> addOnIds,
    Product product,
    bool isGift,
    bool isFree,
  ) {
    this._price = price;
    this._points = points;
    this._discountedPrice = discountedPrice;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._product = product;
    this._isGift = isGift;
    this._isFree = isFree;
  }

  double get price => _price;

  double get points => _points;

  double get discountedPrice => _discountedPrice;

  List<Variation> get variation => _variation;

  double get discountAmount => _discountAmount;

  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;

  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;

  double get taxAmount => _taxAmount;

  List<AddOn> get addOnIds => _addOnIds;

  Product get product => _product;

  bool get isGift => _isGift;

  bool get isFree => _isFree;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _points = json['points'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _isGift = json['_isGift'];
    _isFree = json['_isFree'];
    _taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['points'] = this._points;
    data['discounted_price'] = this._discountedPrice;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['_isGift'] = this._isGift;
    data['_isFree'] = this._isFree;
    data['tax_amount'] = this._taxAmount;
    if (this._addOnIds != null) {
      data['add_on_ids'] = this._addOnIds.map((v) => v.toJson()).toList();
    }
    data['product'] = this._product.toJson();

    return data;
  }
}

class AddOn {
  int _id;
  int _quantity;

  AddOn({int id, int quantity}) {
    this._id = id;
    this._quantity = quantity;
  }

  int get id => _id;

  int get quantity => _quantity;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['quantity'] = this._quantity;
    return data;
  }
}

class CateringCartModel {
  double _price;

  double _discountedPrice;

  double _discountAmount;
  int _quantity;

  SpecialOfferModel _catering;

  CateringCartModel(
    double price,
    double discountedPrice,
    double discountAmount,
    int quantity,
    SpecialOfferModel catering,
  ) {
    this._price = price;

    this._discountedPrice = discountedPrice;

    this._discountAmount = discountAmount;
    this._quantity = quantity;

    this._catering = catering;
  }

  double get price => _price;

  double get discountedPrice => _discountedPrice;

  double get discountAmount => _discountAmount;

  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;

  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;

  SpecialOfferModel get catering => _catering;

  CateringCartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();

    _discountedPrice = json['discounted_price'].toDouble();

    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];

    if (json['catering'] != null) {
      _catering = SpecialOfferModel.fromJson(json['catering']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;

    data['discounted_price'] = this._discountedPrice;

    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;

    data['catering'] = this._catering.toJson();
    return data;
  }
}
class DealCartModel {
  double _price;

  double _discountedPrice;

  double _discountAmount;
  int _quantity;

  DealsDataModel _dealsDataModel;

  DealCartModel(
    double price,
    double discountedPrice,
    double discountAmount,
    int quantity,
    DealsDataModel dealsDataModel,
  ) {
    this._price = price;

    this._discountedPrice = discountedPrice;

    this._discountAmount = discountAmount;
    this._quantity = quantity;

    this._dealsDataModel = dealsDataModel;
  }

  double get price => _price;

  double get discountedPrice => _discountedPrice;

  double get discountAmount => _discountAmount;

  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;

  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;

  DealsDataModel get deal => _dealsDataModel;

  DealCartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();

    _discountedPrice = json['discounted_price'].toDouble();

    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];

    if (json['catering'] != null) {
      _dealsDataModel = DealsDataModel.fromJson(json['deals']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;

    data['discounted_price'] = this._discountedPrice;

    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;

    data['deals'] = this..toJson();
    return data;
  }
}

class HappyHoursCartModel {
  double _price;


  double _discountAmount;
  int _quantity;

  OfferProduct _happyHours;

  HappyHoursCartModel(
    double price,

    double discountAmount,
    int quantity,
    OfferProduct happyHours,
  ) {
    this._price = price;



    this._discountAmount = discountAmount;
    this._quantity = quantity;

    this._happyHours = happyHours;
  }

  double get price => _price;


  double get discountAmount => _discountAmount;

  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;

  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;

  OfferProduct get happyHours => _happyHours;

  HappyHoursCartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();


    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];

    if (json['happy_hours'] != null) {
      _happyHours = OfferProduct.fromJson(json['happy_hours']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;


    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;

    data['happy_hours'] = this._happyHours.toJson();
    return data;
  }
}
