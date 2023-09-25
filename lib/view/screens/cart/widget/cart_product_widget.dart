import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/home/widget/marque_text.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;

  CartProductWidget(
      {@required this.cart,
      @required this.cartIndex,
      @required this.isAvailable,
      @required this.addOns});

  @override
  Widget build(BuildContext context) {
    String _variationText = '';
    if (cart.variation != null && cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type != null
          ? cart.variation[0].type.split('-')
          : [];
      if (_variationTypes.length == cart.product.choiceOptions.length) {
        int _index = 0;
        cart.product.choiceOptions.forEach((choice) {
          _variationText = _variationText +
              '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText = cart.product.variations[0].type;
      }
    }
    return InkWell(
      onTap: () {
        if (!cart.isFree || cart.price != 0.0) {
          ResponsiveHelper.isMobile(context)
              ? showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => CartBottomSheet(
                    product: cart.product,
                    cartIndex: cartIndex,
                    cart: cart,
                    fromCart: true,
                    callback: (CartModel cartModel) {
                      showCustomSnackBar(
                          getTranslated('updated_in_cart', context), context,
                          isError: false);
                    },
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (con) => Dialog(
                        child: CartBottomSheet(
                          product: cart.product,
                          cartIndex: cartIndex,
                          cart: cart,
                          fromCart: true,
                          callback: (CartModel cartModel) {
                            showCustomSnackBar(
                                getTranslated('updated_in_cart', context),
                                context,
                                isError: false);
                          },
                        ),
                      ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child:
                Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false)
                  .removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(cartIndex);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 700
                            : 300],
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_image,
                            height: 70,
                            width: 85,
                            fit: BoxFit.cover,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cart.product.image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder_image,
                                height: 70,
                                width: 85,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cart.product.name,
                                style: rubikMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            // RatingBar(
                            //     rating: cart.product.rating.length > 0
                            //         ? double.parse(
                            //             cart.product.rating[0].average)
                            //         : 0.0,
                            //     size: 12),
                            SizedBox(height: 5),
                            Row(children: [
                              Flexible(
                                child: Text(
                                  cart.isFree
                                      ? '${cart.points} heart points'
                                      : PriceConverter.convertPrice(
                                          context, cart.price),
                                  style: rubikBold,
                                ),
                              ),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              cart.discountAmount > 0
                                  ? Flexible(
                                      child: Text(
                                          PriceConverter.convertPrice(
                                              context,
                                              cart.discountedPrice +
                                                  cart.discountAmount),
                                          style: rubikBold.copyWith(
                                            color: ColorResources.COLOR_GREY,
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          )),
                                    )
                                  : SizedBox(),
                            ]),
                            cart.product.variations.length > 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: MarqueeWidget(
                                              backDuration:
                                                  Duration(microseconds: 500),
                                              animationDuration:
                                                  Duration(microseconds: 500),
                                              direction: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  // Text(
                                                  //   '${getTranslated('variation', context)}: ',
                                                  //   style:
                                                  //       poppinsRegular.copyWith(
                                                  //           fontSize: Dimensions
                                                  //               .FONT_SIZE_SMALL),
                                                  // ),
                                                  Text(_variationText,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  )
                                : SizedBox(),
                          ]),
                    ),
                    cart.isGift == true
                        ? Text(
                            'Your\nGift',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          )
                        : cart.isFree
                            ? Text(
                                'Free',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.center,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      if (cart.quantity > 1) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .setQuantity(
                                                isIncrement: false,
                                                fromProductView: false,
                                                cart: cart,
                                                productIndex: null);
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(cartIndex);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(Icons.remove, size: 20),
                                    ),
                                  ),
                                  Text(cart.quantity.toString(),
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_EXTRA_LARGE)),
                                  InkWell(
                                    onTap: () {
                                      print('==is gift:${cart.price}');
                                      if (cart.isFree) {}

                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .removeCouponData(true);
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .setQuantity(
                                              isIncrement: true,
                                              fromProductView: false,
                                              cart: cart,
                                              productIndex: null);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Icon(Icons.add, size: 20),
                                    ),
                                  ),
                                ]),
                              ),
                    // !ResponsiveHelper.isMobile(context)
                    //     ? Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: Dimensions.PADDING_SIZE_SMALL),
                    //         child: IconButton(
                    //           onPressed: () {
                    //             Provider.of<CouponProvider>(context,
                    //                     listen: false)
                    //                 .removeCouponData(true);
                    //             Provider.of<CartProvider>(context,
                    //                     listen: false)
                    //                 .removeFromCart(cartIndex);
                    //           },
                    //           icon: Icon(Icons.delete, color: Colors.red),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ]),
                  addOns.length > 0
                      ? SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_SMALL),
                            itemCount: addOns.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: Dimensions.PADDING_SIZE_SMALL),
                                child: Row(children: [
                                  InkWell(
                                    onTap: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeAddOn(cartIndex, index);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: Icon(Icons.remove_circle,
                                          color: Theme.of(context).primaryColor,
                                          size: 18),
                                    ),
                                  ),
                                  Text(addOns[index].name, style: rubikRegular),
                                  SizedBox(width: 2),
                                  Text(
                                      PriceConverter.convertPrice(
                                          context, addOns[index].price),
                                      style: rubikMedium),
                                  SizedBox(width: 2),
                                  Text('(${cart.addOnIds[index].quantity})',
                                      style: rubikRegular),
                                ]),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CartOfferWidget extends StatelessWidget {
  final CateringCartModel cateringCartModel;
  final int cartIndex;

  CartOfferWidget({
    @required this.cartIndex,
    this.cateringCartModel,
  });

  @override
  Widget build(BuildContext context) {
    String _variationText = '';

    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child:
                Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false)
                  .removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(cartIndex);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 700
                            : 300],
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_image,
                            height: 70,
                            width: 85,
                            fit: BoxFit.cover,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cateringCartModel.catering.offerProduct.image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder_image,
                                height: 70,
                                width: 85,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cateringCartModel.catering.name,
                                style: rubikMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            // RatingBar(
                            //     rating: cart.product.rating.length > 0
                            //         ? double.parse(
                            //             cart.product.rating[0].average)
                            //         : 0.0,
                            //     size: 12),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Tray Quantity : ${cateringCartModel.catering.offerProduct.itemQuantity}',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),

                            Row(children: [
                              Flexible(
                                child: Text(
                                  PriceConverter.convertPrice(context,
                                      cateringCartModel.discountAmount ?? 0.0),
                                ),
                              ),
                            ]),
                          ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false)
                                .removeCouponData(true);
                            if (cateringCartModel.quantity > 1) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .setQuantity(
                                      isIncrement: false,
                                      fromProductView: false,
                                      isCatering: true,
                                      isCart: false,
                                      catering: cateringCartModel,
                                      productIndex: null);
                            } else {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeFromCart(cartIndex,
                                      isCatering: true, isCart: false);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.remove, size: 20),
                          ),
                        ),
                        Text(cateringCartModel.quantity.toString(),
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false)
                                .removeCouponData(true);
                            Provider.of<CartProvider>(context, listen: false)
                                .setQuantity(
                                    isIncrement: true,
                                    fromProductView: false,
                                    isCatering: true,
                                    isCart: false,
                                    catering: cateringCartModel,
                                    productIndex: null);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ]),
                    ),
                    // !ResponsiveHelper.isMobile(context)
                    //     ? Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: Dimensions.PADDING_SIZE_SMALL),
                    //         child: IconButton(
                    //           onPressed: () {
                    //             Provider.of<CouponProvider>(context,
                    //                     listen: false)
                    //                 .removeCouponData(true);
                    //             Provider.of<CartProvider>(context,
                    //                     listen: false)
                    //                 .removeFromCart(cartIndex);
                    //           },
                    //           icon: Icon(Icons.delete, color: Colors.red),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CartHappyHourWidget extends StatelessWidget {
  final HappyHoursCartModel happyHoursCartModel;
  final int cartIndex;

  CartHappyHourWidget({
    @required this.cartIndex,
    this.happyHoursCartModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child:
                Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false)
                  .removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(cartIndex);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 700
                            : 300],
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_image,
                            height: 70,
                            width: 85,
                            fit: BoxFit.cover,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${happyHoursCartModel.happyHours.image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder_image,
                                height: 70,
                                width: 85,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(happyHoursCartModel.happyHours.name,
                                style: rubikMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            // RatingBar(
                            //     rating: cart.product.rating.length > 0
                            //         ? double.parse(
                            //             cart.product.rating[0].average)
                            //         : 0.0,
                            //     size: 12),
                            SizedBox(height: 5),
                            Text(
                              'Actual Price : ${happyHoursCartModel.price}',
                            ),
                            SizedBox(height: 5),

                            Row(children: [
                              Flexible(
                                child: Text(
                                  'Happy Price : ${happyHoursCartModel.discountAmount}',
                                ),
                              ),
                            ]),
                          ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false)
                                .removeCouponData(true);
                            if (happyHoursCartModel.quantity > 1) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .setQuantity(
                                      isIncrement: false,
                                      fromProductView: false,
                                      isCart: false,
                                      isHappyHours: true,
                                      happyHours: happyHoursCartModel,
                                      productIndex: null);
                            } else {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeFromCart(cartIndex,
                                      isCatering: false,
                                      isCart: false,
                                      isHappyHours: true);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.remove, size: 20),
                          ),
                        ),
                        Text(happyHoursCartModel.quantity.toString(),
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false)
                                .removeCouponData(true);
                            Provider.of<CartProvider>(context, listen: false)
                                .setQuantity(
                                    isIncrement: true,
                                    fromProductView: false,
                                    isCart: false,
                                    isHappyHours: true,
                                    happyHours: happyHoursCartModel,
                                    productIndex: null);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ]),
                    ),
                    // !ResponsiveHelper.isMobile(context)
                    //     ? Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: Dimensions.PADDING_SIZE_SMALL),
                    //         child: IconButton(
                    //           onPressed: () {
                    //             Provider.of<CouponProvider>(context,
                    //                     listen: false)
                    //                 .removeCouponData(true);
                    //             Provider.of<CartProvider>(context,
                    //                     listen: false)
                    //                 .removeFromCart(cartIndex);
                    //           },
                    //           icon: Icon(Icons.delete, color: Colors.red),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
