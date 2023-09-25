
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/profile_provider.dart';
import 'package:intl/intl.dart';

import '../../utill/app_toast.dart';
import '../../utill/routes.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool isFromPoinst;
  ProductWidget({@required this.product,this.isFromPoinst=false});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if(product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price;
    }

    double  _discountedPrice = PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context);




    return Consumer<CartProvider>(
        builder: (context, _cartProvider, child) {
          String _productImage = '';
          try{
            _productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}';
          }catch(e) {

          }
          int _cartIndex =   _cartProvider.getCartIndex(product);
          print('---image${ _productImage}');
        return Padding(
          padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          child: InkWell(
            onTap: () {
              print('----here tap');
              if(isFromPoinst){
                debugPrint('==:${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point<double.parse(product.loyaltyPoints)}');
                if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point<double.parse(product.loyaltyPoints)){
                  showCustomSnackBar('You don\'t have enough hearts to get this product free', context);


                }else{
                  _addToCart(context, _cartIndex);

                }


              }else{

                _addToCart(context, _cartIndex);

              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).darkTheme &&ResponsiveHelper.isDesktop(context)?Colors.black38: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )],
              ),
              child: Row(children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_image, height:ResponsiveHelper.isMobile(context)?50: 80, width:ResponsiveHelper.isMobile(context)?50: 95, fit: BoxFit.cover,
                        image: _productImage,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height:ResponsiveHelper.isMobile(context)?50: 80, width:ResponsiveHelper.isMobile(context)?50: 95, fit: BoxFit.cover),
                      ),
                    ),
                    // _isAvailable ? SizedBox() : Positioned(
                    //   top: 0, left: 0, bottom: 0, right: 0,
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                    //     child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                    //       color: Colors.white, fontSize: 8,
                    //     )),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(product.name, style: rubikMedium.copyWith(fontSize: 12), maxLines: 2,),
                    // SizedBox(height: 5),
                    // product.rating != null ? RatingBar(
                    //   rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 10,
                    // ) : SizedBox(),
                    SizedBox(height: 5),
                    Text(
                     product.price==0.0?'${product.loyaltyPoints} hearts': '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                          '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount,
                          discountType: product.discountType)}' : ''}',
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    product.price > _discountedPrice ? Text('${PriceConverter.convertPrice(context, _startingPrice)}'
                        '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}', style: rubikMedium.copyWith(
                      color: ColorResources.COLOR_GREY,
                      decoration: TextDecoration.lineThrough,
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    )) : SizedBox(),
                  ]),
                ),
                Column(


                    crossAxisAlignment: CrossAxisAlignment.end, children: [

                    WishButton(product: product, edgeInset: EdgeInsets.all(5)),

                  Expanded(child: SizedBox()),
                 isFromPoinst?SizedBox(): Consumer<ProductProvider>(builder: (context,_productProvider,child){
                    Variation _variation = Variation();

                    return                   InkWell(
                        onTap: (){
                          if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
                            debugPrint(
                                '==cehck listid:${product.choiceOptions
                                    .length}');
                            if (!_cartProvider.cartList
                                .map((e) => e.product.id)
                                .contains(product.id)) {
                              if (product.choiceOptions
                                  .length !=
                                  0) {
                                List<double> _priceList =
                                [];
                                product.variations.forEach(
                                        (variation) =>
                                        _priceList.add(
                                            variation
                                                .price));
                                _priceList.sort((a, b) =>
                                    a.compareTo(b));
                                _startingPrice =
                                _priceList[0];
                                if (_priceList[0] <
                                    _priceList[
                                    _priceList.length -
                                        1]) {
                                  _endingPrice = _priceList[
                                  _priceList.length -
                                      1];
                                }
                              } else {
                                _startingPrice =
                                    product.price;
                              }

                              List<String> _variationList =
                              [];
                              for (int index = 0;
                              index <
                                  product.choiceOptions
                                      .length;
                              index++) {
                                print('===index:${_productProvider
                                    .variationIndex}');
                                _variationList.add(product
                                    .choiceOptions[index]
                                    .options[_productProvider
                                    .variationIndex[
                                index]]
                                    .replaceAll(' ', ''));
                              }
                              String variationType = '';
                              bool isFirst = true;
                              _variationList
                                  .forEach((variation) {
                                if (isFirst) {
                                  variationType =
                                  '$variationType$variation';
                                  isFirst = false;
                                } else {
                                  variationType =
                                  '$variationType-$variation';
                                }
                              });

                              double price = product.price;
                              for (Variation variation
                              in product.variations) {
                                if (variation.type ==
                                    variationType) {
                                  price = variation.price;
                                  _variation = variation;
                                  break;
                                }
                              }
                              double priceWithDiscount =
                              PriceConverter
                                  .convertWithDiscount(
                                  context,
                                  price,
                                  product.discount,
                                  product
                                      .discountType);
                              double addonsCost = 0;
                              List<AddOn> _addOnIdList = [];


                              DateTime _currentTime =
                                  Provider.of<SplashProvider>(
                                      context,
                                      listen: false)
                                      .currentTime;
                              DateTime _start = DateFormat(
                                  'hh:mm:ss')
                                  .parse(product
                                  .availableTimeStarts);
                              DateTime _end = DateFormat(
                                  'hh:mm:ss')
                                  .parse(product
                                  .availableTimeEnds);
                              DateTime _startTime =
                              DateTime(
                                  _currentTime.year,
                                  _currentTime.month,
                                  _currentTime.day,
                                  _start.hour,
                                  _start.minute,
                                  _start.second);
                              DateTime _endTime = DateTime(
                                  _currentTime.year,
                                  _currentTime.month,
                                  _currentTime.day,
                                  _end.hour,
                                  _end.minute,
                                  _end.second);
                              if (_endTime
                                  .isBefore(_startTime)) {
                                _endTime = _endTime
                                    .add(Duration(days: 1));
                              }
                              bool _isAvailable =
                                  _currentTime.isAfter(
                                      _startTime) &&
                                      _currentTime.isBefore(
                                          _endTime);

                              CartModel _cartModel = CartModel(
                                  price,
                                  0.0,
                                  priceWithDiscount,
                                  [_variation],
                                  (price -
                                      PriceConverter
                                          .convertWithDiscount(
                                          context,
                                          price,
                                          product
                                              .discount,
                                          product
                                              .discountType)),
                                  1,
                                  price -
                                      PriceConverter
                                          .convertWithDiscount(
                                          context,
                                          price,
                                          product.tax,
                                          product
                                              .taxType),
                                  _addOnIdList,
                                  product,
                                  false,false);

                              _cartProvider.addToCart(
                                  _cartModel, _cartIndex);
                              appToast(text: 'Item added!',toastColor: Colors.green);


                            } else {
                              Provider.of<CartProvider>(context,
                                  listen: false)
                                  .setQuantity(
                                  isIncrement: true,
                                  fromProductView: false,
                                  cart:  _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0],
                                  productIndex: null);


                              appToast(text: 'Item added ${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString()} times!',toastColor: Colors.green);

                            }
                          }else{
                            Navigator.pushNamed(context, Routes.getLoginRoute());

                            //  appToast(text: 'You need to login first');
                          }
                        },
                        child:Icon(Icons.add));


                  })
                ]),
              ]),
            ),
          ));
      }
    );
  }

  void _addToCart(
      BuildContext context,
      int _cartIndex,
      ) {
    print('===show sheet:${isFromPoinst}');
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheet(
        product: product,
        cart: _cartIndex != null
            ? Provider.of<CartProvider>(context, listen: false)
            .cartList[_cartIndex]
            : null,
        fromPoints: isFromPoinst,
        callback: (CartModel cartModel) {
          showCustomSnackBar(
              getTranslated('added_to_cart', context), context,
              isError: false);
        },
      ),
    )
        : showDialog(
        context: context,
        builder: (con) => Dialog(
          child: CartBottomSheet(
            product: product,
            fromSetMenu: true,
            cart: _cartIndex != null
                ? Provider.of<CartProvider>(context, listen: false)
                .cartList[_cartIndex]
                : null,
            fromPoints: isFromPoinst,
            callback: (CartModel cartModel) {
              showCustomSnackBar(
                  getTranslated('added_to_cart', context), context,
                  isError: false);
            },
          ),
        ));
  }

}
