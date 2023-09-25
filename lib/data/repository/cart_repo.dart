import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/deals_data_model.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({@required this.sharedPreferences});

  List<CartModel> getCartList() {
    debugPrint('------getCartList-----');

    List<String> carts = [];
    if(sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST);
    }
    List<CartModel> cartList = [];
    carts.forEach((cart) => cartList.add(CartModel.fromJson(jsonDecode(cart))) );
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    debugPrint('------addToCartList-----');

    List<String> carts = [];
    cartProductList.forEach((cartModel) => carts.add(jsonEncode(cartModel)) );
    sharedPreferences.setStringList(AppConstants.CART_LIST, carts);
  }
  void addToCateringList(List<CateringCartModel> cartCateringList) {
    debugPrint('------addToCartList-----');

    List<String> caterings = [];
    //ca.forEach((cartModel) => carts.add(jsonEncode(cartModel)) );
    sharedPreferences.setStringList(AppConstants.CATERING_LIST, caterings);
  }
  void addToHappyHoursList(List<HappyHoursCartModel> happyHoursList) {
    debugPrint('------addToCartList-----');

    List<String> carts = [];
    //happyHoursList.forEach((cartModel) => carts.add(jsonEncode(cartModel)) );
    sharedPreferences.setStringList(AppConstants.HAPPY_HOURS_LIST, carts);
  }
  void addToDealList(List<DealCartModel> deals) {
    debugPrint('------addToCartList-----');

    List<String> carts = [];
    //happyHoursList.forEach((cartModel) => carts.add(jsonEncode(cartModel)) );
    sharedPreferences.setStringList(AppConstants.HAPPY_HOURS_LIST, carts);
  }

}