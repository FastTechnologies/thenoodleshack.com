import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/deals_data_model.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartModel> _cartList = [];
  List<CateringCartModel> _cateringList = [];
  List<DealCartModel> _dealsList = [];
  List<HappyHoursCartModel> _happyHoursList = [];
  double _amount = 0.0;
  double taxFee = 0.0;
  double tip = 0.0;
  double deliveryCharge = 0.0;
  bool _isCartUpdate = false;
  bool _isFromCategory=false;
  bool  get  isFromCategory=> _isFromCategory;
  List<CartModel> get cartList => _cartList;
  List<CateringCartModel> get cateringList => _cateringList;
  List<DealCartModel> get dealsList => _dealsList;
  List<HappyHoursCartModel> get happyHoursList => _happyHoursList;
  double get amount => _amount;
  bool get isCartUpdate => _isCartUpdate;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }
void setFalse(){
  _isFromCategory=false;

}
  void addToCart(CartModel cartModel, int index) {
    _isFromCategory=true;
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index+1, [cartModel]);
    }else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }
  void addCateringToCart(CateringCartModel catering, int index) {
    if(index != null && index != -1) {
      _cateringList.replaceRange(index, index+1, [catering]);
    }else {
     _cateringList.add(catering);
    }
     cartRepo.addToCateringList(_cateringList);
    notifyListeners();
  }
  void addDealToCart(DealCartModel dealCartModel, int index) {
    if(index != null && index != -1) {
      _dealsList.replaceRange(index, index+1, [dealCartModel]);
    }else {
     _dealsList.add(dealCartModel);
    }
     cartRepo.addToCateringList(_cateringList);
    notifyListeners();
  }
  void addHappyHoursToCart(HappyHoursCartModel offerProduct, int index) {
    if(index != null && index != -1) {
      _happyHoursList.replaceRange(index, index+1, [offerProduct]);
    }else {
      _happyHoursList.add(offerProduct);
    }
    cartRepo.addToHappyHoursList(_happyHoursList);
    notifyListeners();
  }

  void setQuantity(
      {
        bool isIncrement,
        bool isCart=true,
        bool isCatering=false,
        bool isHappyHours=false,
        bool isDeal=false,
      CartModel cart,
      CateringCartModel catering,
      HappyHoursCartModel happyHours,
        DealCartModel dealCartModel,
      int productIndex,
      bool fromProductView}) {
   if(isCart){
     int index = fromProductView ? productIndex :  _cartList.indexOf(cart);
     if (isIncrement) {
       _cartList[index].quantity = _cartList[index].quantity + 1;
       _amount = _amount + _cartList[index].discountedPrice;
     } else {
       _cartList[index].quantity = _cartList[index].quantity - 1;
       _amount = _amount - _cartList[index].discountedPrice;
     }
     cartRepo.addToCartList(_cartList);
   }
   if(isCatering){
     int index = fromProductView ? productIndex :  _cateringList.indexOf(catering);
     if (isIncrement) {
       _cateringList[index].quantity = _cateringList[index].quantity + 1;
       _amount = _amount + _cateringList[index].discountAmount;
     } else {
       _cateringList[index].quantity = _cateringList[index].quantity - 1;
       _amount = _amount - cateringList[index].discountAmount;
     }
     cartRepo.addToCartList(_cartList);
   }
   if(isHappyHours){
     int index = fromProductView ? productIndex :  _happyHoursList.indexOf(happyHours);
     if (isIncrement) {
       _happyHoursList[index].quantity = _happyHoursList[index].quantity + 1;
       _amount = _amount + _happyHoursList[index].discountAmount;
     } else {
       _happyHoursList[index].quantity = _happyHoursList[index].quantity - 1;
       _amount = _amount - _happyHoursList[index].discountAmount;
     }
     cartRepo.addToHappyHoursList(_happyHoursList);
   }
   if(isDeal){
     int index = fromProductView ? productIndex :  _dealsList.indexOf(dealCartModel);
     if (isIncrement) {
       _dealsList[index].quantity = _dealsList[index].quantity + 1;
       _amount = _amount + _dealsList[index].discountAmount;
     } else {
       _dealsList[index].quantity = _dealsList[index].quantity - 1;
       _amount = _amount - _dealsList[index].discountAmount;
     }
     cartRepo.addToDealList(_dealsList);
   }

    notifyListeners();
  }

  void removeFromCart(int index,{
    bool isCart=true,
    bool isCatering=false,
    bool isHappyHours=false,
    bool isDeal=false,
  }) {
    if(isCart){
      _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
      _cartList.removeAt(index);
      cartRepo.addToCartList(_cartList);
    }
    if(isCatering){
      _amount = _amount - (_cateringList[index].discountAmount * _cateringList[index].quantity);
      _cateringList.removeAt(index);
      cartRepo.addToCateringList(_cateringList);
    }
    if(isHappyHours){
      _amount = _amount - (_happyHoursList[index].discountAmount * _happyHoursList[index].quantity);
      _happyHoursList.removeAt(index);
      cartRepo.addToHappyHoursList(_happyHoursList);
    }
    if(isDeal){
      _amount = _amount - (_dealsList[index].discountAmount * _dealsList[index].quantity);
      _dealsList.removeAt(index);
      cartRepo.addToDealList(_dealsList);
    }

    notifyListeners();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _cateringList=[];
    _happyHoursList=[];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    cartRepo.addToCateringList(_cateringList);
    cartRepo.addToHappyHoursList(_happyHoursList);
    notifyListeners();
  }

  int isExistInCart(int productId, String variationType, bool isUpdate, int cartIndex,) {
    for(int index = 0; index<_cartList.length; index++) {
      if(_cartList[index].product.id == productId && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type == variationType : true)) {
        if((isUpdate && index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }
  int getCartProductIndex (CartModel cartModel) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product.id == cartModel.product.id && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type == cartModel.variation[0].type : true)) {
        return index;
      }
    }
    return null;
  }
  int getCartIndex (Product product) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product.id == product.id ) {
        return index;
      }
    }
    return null;
  }
  int getCartCateringIndex (SpecialOfferModel catering) {
    for(int index = 0; index < _cateringList.length; index ++) {
      if(_cateringList[index].catering.id == catering.id ) {
        return index;
      }
    }
    return null;
  }
  int getCartHappyHoursIndex (OfferProduct happyHour) {
    for(int index = 0; index < _happyHoursList.length; index ++) {
      if(_happyHoursList[index].happyHours.id == happyHour.id ) {
        return index;
      }
    }
    return null;
  }
  int getCarDealIndex (DealsDataModel dataModel) {
    for(int index = 0; index < _dealsList.length; index ++) {
      if(_dealsList[index].deal.id == dataModel.id ) {
        return index;
      }
    }
    return null;
  }
  setCartUpdate(bool isUpdate) {
    _isCartUpdate = isUpdate;
    if(_isCartUpdate) {
      notifyListeners();
    }

  }

}
