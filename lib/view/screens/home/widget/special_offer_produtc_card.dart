import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';

import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:intl/intl.dart';

import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

import 'package:provider/provider.dart';

import '../../../../helper/price_converter.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/coupon_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/app_toast.dart';
import '../../../../utill/routes.dart';
import '../../../base/custom_snackbar.dart';

class SpecialOfferProductCard extends StatefulWidget {
  final isBuffet;
  final isCatering;
  final isHappyHours;
  SpecialOfferModel specialOfferModel;
  OfferProduct offerProduct;

  SpecialOfferProductCard(
      {Key key,
      this.isBuffet = false,
      this.isCatering = false,
      this.isHappyHours = false,
      this.specialOfferModel,
      this.offerProduct})
      : super(key: key);

  @override
  State<SpecialOfferProductCard> createState() =>
      _SpecialOfferProductCardState();
}

class _SpecialOfferProductCardState extends State<SpecialOfferProductCard> {
  @override
  Widget build(BuildContext context) {
    var _total = widget.specialOfferModel.offerProduct != null
        ? (double.parse(
                widget.specialOfferModel.offerProduct.itemQuantity.toString()) *
            double.parse(widget.specialOfferModel.offerProduct.itemPrice))
        : 0;
    var discount = widget.specialOfferModel.offerProduct != null
        ? _total -
            double.parse(
                widget.specialOfferModel.offerProduct.itemDiscountPrice)
        : 0;
    var _subtotal = widget.specialOfferModel.offerProduct != null
        ? widget.specialOfferModel.offerProduct.itemDiscountPrice
        : 0;
    var _image = widget.isCatering
        ? widget.specialOfferModel.offerProduct.image
        : widget.offerProduct.image;
    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      int _cartIndex = widget.isCatering
          ? _cartProvider.getCartCateringIndex(widget.specialOfferModel)
          : _cartProvider.getCartHappyHoursIndex(widget.offerProduct);

      return InkWell(
        onTap: () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            if (widget.isCatering) {
              CateringCartModel cartModel = CateringCartModel(_total, 0.0,
                  double.parse(_subtotal), 1, widget.specialOfferModel);

              if (!_cartProvider.cateringList
                  .map((e) => e.catering.id)
                  .contains(widget.specialOfferModel.id)) {
                _cartProvider.addCateringToCart(cartModel, _cartIndex);
                // appToast(text: 'Item added!',toastColor: Colors.green);
              } else {
                Provider.of<CartProvider>(context, listen: false).setQuantity(
                    isIncrement: true,
                    fromProductView: false,
                    isCatering: true,
                    isCart: false,
                    catering: _cartProvider.cateringList
                        .where((element) =>
                            element.catering.id == widget.specialOfferModel.id)
                        .toList()[0],
                    productIndex: null);

                //appToast(text: 'Item added ${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString()} times!',toastColor: Colors.green);
              }
            }

            if (widget.isHappyHours) {
              DateTime _currentTime =
                  Provider
                      .of<SplashProvider>(context, listen: false)
                      .currentTime;
              DateTime _start =
              DateFormat('hh:mm:ss').parse(
                  widget.specialOfferModel.offerAvailableTimeStarts+':00');
              DateTime _end =
              DateFormat('hh:mm:ss').parse(
                  widget.specialOfferModel.offerAvailableTimeEnds+':00');
              DateTime _startTime = DateTime(
                  _currentTime.year, _currentTime.month,
                  _currentTime.day, _start.hour, _start.minute, _start.second);
              DateTime _endTime = DateTime(
                  _currentTime.year, _currentTime.month,
                  _currentTime.day, _end.hour, _end.minute, _end.second);
              if (_endTime.isBefore(_startTime)) {
                _endTime = _endTime.add(Duration(days: 1));
              }
              bool _isAvailable =
                  _currentTime.isAfter(_startTime) &&
                      _currentTime.isBefore(_endTime);
              if(_isAvailable){
                HappyHoursCartModel _happyHoursModel = HappyHoursCartModel(
                    double.parse(widget.offerProduct.itemPrice),
                    double.parse(widget.offerProduct.itemDiscountPrice),
                    1,
                    widget.offerProduct);

                if (!_cartProvider.happyHoursList
                    .map((e) => e.happyHours.id)
                    .contains(widget.offerProduct.id)) {
                  _cartProvider.addHappyHoursToCart(_happyHoursModel, _cartIndex);
                  // appToast(text: 'Item added!',toastColor: Colors.green);
                } else {
                  Provider.of<CartProvider>(context, listen: false).setQuantity(
                      isIncrement: true,
                      fromProductView: false,
                      isHappyHours: true,
                      happyHours: _cartProvider.happyHoursList
                          .where((element) =>
                      element.happyHours.id == widget.offerProduct.id)
                          .toList()[0],
                      productIndex: null);

                  //appToast(text: 'Item added ${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString()} times!',toastColor: Colors.green);
                }

              }else{

                appToast(text: 'Not available now');


              }
            }
          } else {
            Navigator.pushNamed(context, Routes.getLoginRoute());

            //  appToast(text: 'You need to login first');
          }
        },
        child: Container(
          // height: 180 ,
          width: widget.isBuffet ? 100 : 150,
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
                        Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                    spreadRadius:
                        Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
              ]),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_rectangle,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 150,
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${_image}',
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder_rectangle,
                        fit: BoxFit.cover,
                        height: 90,
                        width: 150),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isCatering
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.specialOfferModel.name}',
                                      style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Spacer(),
                                        Text(
                                          '${widget.specialOfferModel.offerProduct.itemQuantity}',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Actual price:',
                                            style: rubikMedium.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          _total.toStringAsFixed(2),
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Discount:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Spacer(),
                                        Text(
                                          '- ${discount.toStringAsFixed(2)}',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total price:',
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Spacer(),
                                        Text(
                                          _subtotal,
                                          style: rubikMedium.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          widget.isBuffet
                              ? Column(
                                  children: [
                                    Text(
                                      '${widget.offerProduct.name}',
                                      style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          widget.isHappyHours
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.offerProduct.name}',
                                      style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${PriceConverter.convertPrice(context, double.parse(widget.offerProduct.itemPrice))}',
                                          style: rubikBold.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.COLOR_GREY,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${PriceConverter.convertPrice(context, double.parse(widget.offerProduct.itemDiscountPrice))}',
                                          style: rubikBold.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : SizedBox.shrink()
                        ]),
                  ),
                ),
                widget.isCatering
                    ? (_cartProvider.cateringList
                            .map((e) => e.catering.id)
                            .contains(widget.specialOfferModel.id)
                        ? Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      if (_cartProvider.cateringList
                                              .where((element) =>
                                                  element.catering.id ==
                                                  widget.specialOfferModel.id)
                                              .toList()[0]
                                              .quantity >
                                          1) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .setQuantity(
                                                isIncrement: false,
                                                fromProductView: false,
                                                isCart: false,
                                                isCatering: true,
                                                catering: _cartProvider
                                                    .cateringList
                                                    .where((element) =>
                                                        element.catering.id ==
                                                        widget.specialOfferModel
                                                            .id)
                                                    .toList()[0],
                                                productIndex: null);
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(_cartIndex,
                                                isCart: false,
                                                isCatering: true);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Text(
                                      _cartProvider.cateringList
                                          .where((element) =>
                                              element.catering.id ==
                                              widget.specialOfferModel.id)
                                          .toList()[0]
                                          .quantity
                                          .toString(),
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_EXTRA_LARGE)),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .setQuantity(
                                              isIncrement: true,
                                              fromProductView: false,
                                              isCart: false,
                                              isCatering: true,
                                              catering: _cartProvider
                                                  .cateringList
                                                  .where((element) =>
                                                      element.catering.id ==
                                                      widget
                                                          .specialOfferModel.id)
                                                  .toList()[0],
                                              productIndex: null);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                ]),
                          )
                        : Center(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text('Add to cart',
                                  style: rubikBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Colors.white)),
                            ),
                          ))
                    : SizedBox(),
                widget.isHappyHours
                    ? (_cartProvider.happyHoursList
                            .map((e) => e.happyHours.id)
                            .contains(widget.offerProduct.id)
                        ? Center(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      if (_cartProvider.happyHoursList
                                              .where((element) =>
                                                  element.happyHours.id ==
                                                  widget.offerProduct.id)
                                              .toList()[0]
                                              .quantity >
                                          1) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .setQuantity(
                                                isIncrement: false,
                                                fromProductView: false,
                                                isCart: false,
                                                isHappyHours: true,
                                                happyHours: _cartProvider
                                                    .happyHoursList
                                                    .where((element) =>
                                                        element.happyHours.id ==
                                                        widget.offerProduct.id)
                                                    .toList()[0],
                                                productIndex: null);
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(_cartIndex,
                                                isCart: false,
                                                isHappyHours: true);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Text(
                                      _cartProvider.happyHoursList
                                          .where((element) =>
                                              element.happyHours.id ==
                                              widget.offerProduct.id)
                                          .toList()[0]
                                          .quantity
                                          .toString(),
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_EXTRA_LARGE)),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .setQuantity(
                                              isIncrement: true,
                                              fromProductView: false,
                                              isCart: false,
                                              isHappyHours: true,
                                              happyHours: _cartProvider
                                                  .happyHoursList
                                                  .where((element) =>
                                                      element.happyHours.id ==
                                                      widget.offerProduct.id)
                                                  .toList()[0],
                                              productIndex: null);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                ]),
                          )
                        : Center(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text('Add to cart',
                                  style: rubikBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Colors.white)),
                            ),
                          ))
                    : SizedBox(),
                SizedBox(
                  height: 8,
                )
              ]),
        ),
      );
    });
  }
}
