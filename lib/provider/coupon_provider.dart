import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/coupon_model.dart';
import 'package:flutter_restaurant/data/repository/coupon_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:provider/provider.dart';

import '../data/model/response/cart_model.dart';
import '../data/model/response/product_model.dart';
import '../helper/price_converter.dart';
import 'cart_provider.dart';
import 'package:intl/intl.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo couponRepo;

  CouponProvider({@required this.couponRepo});

  List<CouponModel> _couponList;
  CouponModel _coupon;
  CouponModel gift;
  double _discount = 0.0;
  String _code = '';
  bool _isLoading = false;

  CouponModel get coupon => _coupon;

  double get discount => _discount;

  String get code => _code;

  bool get isLoading => _isLoading;

  List<CouponModel> get couponList => _couponList;

  Future<void> getCouponList(BuildContext context) async {
    ApiResponse apiResponse = await couponRepo.getCouponList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _couponList = [];
      jsonDecode(apiResponse.response.body).forEach(
          (category) => _couponList.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
     // _isLoading=false;
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<double> applyCoupon(String coupon, double order, context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo.applyCoupon(coupon);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _coupon = CouponModel.fromJson(jsonDecode(apiResponse.response.body));
      _code = _coupon.code;
      if (_coupon.discountType == 'product') {
        double _startingPrice;
        double _endingPrice;
        Variation _variation = Variation();

        if (_coupon.product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          _coupon.product.variations
              .forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = _coupon.product.price;
        }

        List<String> _variationList = [];
        for (int index = 0;
            index < _coupon.product.choiceOptions.length;
            index++) {
          _variationList.add(_coupon
              .product
              .choiceOptions[index]
              .options[Provider.of<ProductProvider>(context, listen: false)
                  .variationIndex[index]]
              .replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = _coupon.product.price;
        for (Variation variation in _coupon.product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }
        int _cartIndex = Provider.of<CartProvider>(context, listen: false)
            .getCartIndex(_coupon.product);

        double priceWithDiscount = PriceConverter.convertWithDiscount(context,
            price, _coupon.product.discount, _coupon.product.discountType);
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];

        DateTime _currentTime =
            Provider.of<SplashProvider>(context, listen: false).currentTime;
        DateTime _start =
            DateFormat('hh:mm:ss').parse(_coupon.product.availableTimeStarts);
        DateTime _end =
            DateFormat('hh:mm:ss').parse(_coupon.product.availableTimeEnds);
        DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
            _currentTime.day, _start.hour, _start.minute, _start.second);
        DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
            _currentTime.day, _end.hour, _end.minute, _end.second);
        if (_endTime.isBefore(_startTime)) {
          _endTime = _endTime.add(Duration(days: 1));
        }
        bool _isAvailable =
            _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

        CartModel _cartModel = CartModel(
          0.0,
          0.0,
          priceWithDiscount,
          [_variation],
          0.0,
          //(price - PriceConverter.convertWithDiscount(context, price,  _coupon.discount,  _coupon.product.discountType)),
          Provider.of<ProductProvider>(context, listen: false).quantity,
          price -
              PriceConverter.convertWithDiscount(
                  context, price, _coupon.product.tax, _coupon.product.taxType),
          _addOnIdList,
          _coupon.product,

          true,
          false
        );
        print('==cart add:${_cartModel.discountAmount}');
        print('==cart add:${_cartModel.discountedPrice}');

        Provider.of<CartProvider>(context, listen: false)
            .addToCart(_cartModel, _cartIndex);

        _discount = _coupon.product.price.toDouble();
      } else {
        if (_coupon.minPurchase != null && _coupon.minPurchase <= order) {
          if (_coupon.discountType == 'percent') {
            if (_coupon.maxDiscount != null && _coupon.maxDiscount != 0) {
              _discount = (_coupon.discount * order / 100) < _coupon.maxDiscount
                  ? (_coupon.discount * order / 100)
                  : _coupon.maxDiscount;
            } else {
              _discount = _coupon.discount * order / 100;
            }
          } else {
            if (_coupon.maxDiscount != null) {
              _discount = _coupon.discount.toDouble();
            }
            _discount = _coupon.discount.toDouble();
          }
        } else {
          _discount = 0.0;
        }
      }
    } else {
      print(apiResponse.error.toString());
      _discount = 0.0;
    }
    _isLoading = false;
    notifyListeners();
    return _discount;
  }

  giftCoupon(CouponModel couponModel) async {
    debugPrint('===gift');
    gift = couponModel;
    debugPrint('===gift here: ${gift}');
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _code = '';
    if (notify) {
      notifyListeners();
    }
  }
}
