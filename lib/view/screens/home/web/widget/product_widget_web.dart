import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/auth_provider.dart';
import '../../../../../provider/coupon_provider.dart';
import '../../../../../provider/product_provider.dart';

import 'package:intl/intl.dart';

import '../../../../../provider/profile_provider.dart';
import '../../../../../utill/app_toast.dart';
import '../../../../../utill/routes.dart';

class ProductWidgetWeb extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;
  int index;
  bool isFromCart;
  bool isFromCartSheet;
  bool isFromLoyaltyPoints;

  ProductWidgetWeb(
      {@required this.product,
      this.fromPopularItem = false,
      this.isFromCart = false,
      this.isFromLoyaltyPoints = false,
      this.index,
      this.isFromCartSheet = false});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if (product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations
          .forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = product.price;
    }
    print('=====statring price ${product.name}:${product.price}');

    double priceDiscount = PriceConverter.convertDiscount(
        context, product.price, product.discount, product.discountType);

    bool _isAvailable =
        product.availableTimeStarts != null && product.availableTimeEnds != null
            ? DateConverter.isAvailable(
                product.availableTimeStarts, product.availableTimeEnds, context)
            : false;

    return ResponsiveHelper.isMobilePhone()
        ? _itemView(_isAvailable, priceDiscount, _startingPrice, _endingPrice)
        : OnHover(builder: (isHover) {
            return _itemView(
                _isAvailable, priceDiscount, _startingPrice, _endingPrice);
          });
  }

  void _addToCart(
    BuildContext context,
    int _cartIndex,
  ) {
    print('===show sheet');
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
                    callback: (CartModel cartModel) {
                      showCustomSnackBar(
                          getTranslated('added_to_cart', context), context,
                          isError: false);
                    },
                  ),
                ));
  }

  Consumer<CartProvider> _itemView(bool _isAvailable, double priceDiscount,
      double _startingPrice, double _endingPrice) {
    Variation _variation = Variation();

    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      int _cartIndex = _cartProvider.getCartIndex(product);
      print(
          '=====price ${product.name}:${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}');
      String _productImage = '';
      try {
        _productImage =
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}';
      } catch (e) {}

      return Consumer<ProductProvider>(
          builder: (context, _productProvider, child) {
        return InkWell(
          onTap: () {
            if(isFromCart){
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
                    print('===index:${index}');
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
                  isFromCartSheet
                      ? null
                      : _productProvider
                      .resetQuantity();

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
print('===price $price');
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
                      false,isFromLoyaltyPoints);

                  _cartProvider.addToCart(
                      _cartModel, _cartIndex);
                } else {
                  Provider.of<CartProvider>(
                      context,
                      listen: false)
                      .removeFromCart(
                      _cartIndex);
                }
              }else{
               // appToast(text: 'You need to login first');
                Navigator.pushNamed(context, Routes.getLoginRoute());

              }
            }else{

              if(isFromLoyaltyPoints){
                debugPrint('==:${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point<double.parse(product.loyaltyPoints)}');
                if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point<double.parse(product.loyaltyPoints)){
                  showCustomSnackBar('You don\'t have enough hearts to get this product free', context);


                }else{
                  _addToCart(context, _cartIndex);

                }


              }else{
                _addToCart(context, _cartIndex);

              }

            }


          },
          child: Stack(
            children: [
              Container(
                height: isFromCart ? 180 : 200,
                width: isFromCart ? 100 : null,
                decoration: BoxDecoration(
                    color: ColorResources.getCartColor(context),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[
                              Provider.of<ThemeProvider>(context).darkTheme
                                  ? 800
                                  : 300],
                          blurRadius:
                              Provider.of<ThemeProvider>(context).darkTheme
                                  ? 2
                                  : 5,
                          spreadRadius:
                              Provider.of<ThemeProvider>(context).darkTheme
                                  ? 0
                                  : 1)
                    ]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_rectangle,
                              fit: BoxFit.cover,


                              height: isFromCart ? 80 : 105,
                              width: isFromCart ? 100 : 195,
                              image: _productImage,
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                  Images.placeholder_rectangle,
                                  fit: BoxFit.cover,
                                  height: isFromCart ? 80 : 105,
                                  width: isFromCart ? 100 : 195),
                            ),
                          ),
                          _isAvailable
                              ? SizedBox()
                              : Positioned(
                                  top: 0,
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        color: Colors.black.withOpacity(0.6)),
                                    child: Text(
                                        getTranslated(
                                            'not_available_now', context),
                                        textAlign: TextAlign.center,
                                        style: rubikRegular.copyWith(
                                            color: Colors.white,
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL)),
                                  ),
                                ),
                        ],
                      ),
                      isFromCart
                          ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // SizedBox(
                                      //     height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      //
                                      // RatingBar(
                                      //   rating: product.rating.length > 0 ? double
                                      //       .parse(product.rating[0].average) : 0.0,
                                      //   size: 12,
                                      // ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                              style: rubikBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                            ),
                                          ),
                                          _cartProvider.cartList
                                              .map((e) => e.product.id)
                                              .contains(product.id)
                                              ? SizedBox():   InkWell(
                                              onTap: () {
                                                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()){
                                                  debugPrint(
                                                      '==cehck listid:${product.id}');
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
                                                    isFromCartSheet
                                                        ? null
                                                        : _productProvider
                                                        .resetQuantity();

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
                                                        priceWithDiscount,
                                                        isFromLoyaltyPoints?  double.parse(product.loyaltyPoints):0.0,

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
                                                        false,isFromLoyaltyPoints);

                                                    _cartProvider.addToCart(
                                                        _cartModel, _cartIndex);
                                                  } else {
                                                    Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                        .removeFromCart(
                                                        _cartIndex);
                                                  }
                                                }else{
                                                  Navigator.pushNamed(context, Routes.getLoginRoute());

                                                  //appToast(text: 'You need to login first');
                                                }

                                              },
                                              child: Icon(Icons.add,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color)),


                                        ],
                                      ),
                                      SizedBox(height: 4,),

                                      _cartProvider.cartList
                                          .map((e) => e.product.id)
                                          .contains(product.id)
                                          ?  Row(

                                              children: [
                                            InkWell(
                                              onTap: () {
                                                Provider.of<CouponProvider>(context,
                                                    listen: false)
                                                    .removeCouponData(true);
                                                if (_cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity > 1) {
                                                  Provider.of<CartProvider>(context,
                                                      listen: false)
                                                      .setQuantity(
                                                      isIncrement: false,
                                                      fromProductView: false,
                                                      cart: _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0],
                                                      productIndex: null);
                                                } else {
                                                  Provider.of<CartProvider>(context,
                                                      listen: false)
                                                      .removeFromCart(_cartIndex);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical:
                                                    2),
                                                child: Icon(Icons.remove, size: 20),
                                              ),
                                            ),
                                            Text( _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString(),
                                                style: rubikMedium.copyWith(
                                                    fontSize:
                                                    Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                            InkWell(
                                              onTap: () {
                                                print('==is gift:${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].isFree}');


                                                Provider.of<CouponProvider>(context,
                                                    listen: false)
                                                    .removeCouponData(true);
                                                Provider.of<CartProvider>(context,
                                                    listen: false)
                                                    .setQuantity(
                                                    isIncrement: true,
                                                    fromProductView: false,
                                                    cart:  _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0],
                                                    productIndex: null);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical:
                                                    2),
                                                child: Icon(Icons.add, size: 20),
                                              ),
                                            ),
                                          ]):SizedBox()
                                    ]),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      //
                                      // RatingBar(
                                      //   rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0,
                                      //   size: 12,
                                      // ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),

                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${PriceConverter.convertPrice(context, _startingPrice)}'
                                                '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                                style: rubikBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_SMALL,
                                                  color:
                                                      ColorResources.COLOR_GREY,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ),
                                            Icon(Icons.add,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color),
                                          ])
                                    ]),
                              ),
                            ),

                      // Flexible(
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: Dimensions
                      //         .PADDING_SIZE_SMALL),
                      //     child: Column(crossAxisAlignment: CrossAxisAlignment
                      //         .center, mainAxisAlignment: MainAxisAlignment
                      //         .center, children: [
                      //       Text(product.name, style: rubikMedium.copyWith(
                      //           fontSize: Dimensions.FONT_SIZE_SMALL,
                      //           color: ColorResources.getCartTitleColor(
                      //               context)),
                      //           maxLines: 2,
                      //           overflow: TextOverflow.ellipsis,
                      //           textAlign: TextAlign.center),
                      //       SizedBox(
                      //           height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      //
                      //       RatingBar(
                      //           rating: product.rating.length > 0 ? double
                      //               .parse(product.rating[0].average) : 0.0,
                      //           size: Dimensions.PADDING_SIZE_DEFAULT),
                      //       SizedBox(
                      //           height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      //
                      //       FittedBox(
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             priceDiscount > 0
                      //                 ? Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: Dimensions
                      //                         .PADDING_SIZE_EXTRA_SMALL),
                      //                 child: Text(
                      //                     '${PriceConverter.convertPrice(
                      //                         context,
                      //                         _startingPrice)}''${_endingPrice !=
                      //                         null ? ' - ${PriceConverter
                      //                         .convertPrice(
                      //                         context, _endingPrice)}' : ''}',
                      //                     style: rubikBold.copyWith(
                      //                         fontSize: Dimensions
                      //                             .FONT_SIZE_EXTRA_SMALL,
                      //                         decoration: TextDecoration
                      //                             .lineThrough)))
                      //                 : SizedBox(),
                      //             Text('${PriceConverter.convertPrice(
                      //                 context, _startingPrice,
                      //                 discount: product.discount,
                      //                 discountType: product
                      //                     .discountType)}''${_endingPrice !=
                      //                 null
                      //                 ? ' - ${PriceConverter.convertPrice(
                      //                 context, _endingPrice,
                      //                 discount: product.discount,
                      //                 discountType: product.discountType)}'
                      //                 : ''}',
                      //                 style: rubikBold.copyWith(
                      //                     fontSize: Dimensions
                      //                         .FONT_SIZE_SMALL,
                      //                     color: ColorResources
                      //                         .APPBAR_HEADER_COL0R))
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //           height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      //
                      //       Align(
                      //         alignment: Alignment.center,
                      //         child: SizedBox(
                      //           width: 100,
                      //           child: FittedBox(
                      //               child: ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                       backgroundColor: ColorResources
                      //                           .APPBAR_HEADER_COL0R,
                      //                       shape: RoundedRectangleBorder(
                      //                           borderRadius: BorderRadius
                      //                               .circular(
                      //                               isFromCart ? 10 : 30))),
                      //                   onPressed: () =>
                      //                       _addToCart(context, _cartIndex),
                      //                   child: Icon(Icons.add)
                      //               )),
                      //         ),
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                    ]),
              ),
              isFromCart
                  ? SizedBox()
                  : Positioned.fill(
                      child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WishButton(product: product),
                      ),
                    ))
            ],
          ),
        );
      });
    });
  }
}
