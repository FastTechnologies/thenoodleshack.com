import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/helper/product_type.dart';

import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/address_model.dart';
import '../../../provider/location_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/images.dart';
import '../../base/custom_text_field.dart';
import '../../base/title_widget.dart';
import '../address/widget/permission_dialog.dart';
import '../tip_view/tip_view.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController controller = TextEditingController();
  bool isNotTip = false;
  final tipController=Get.put(TipController());

  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .homeDelivery
          ? 'delivery'
          : 'take_away',
      notify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
          child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(
          context: context,
          title: getTranslated('my_cart', context),
          isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        return Consumer<ProductProvider>(
            builder: (context,
                productProvider,
                child) {
              return Consumer<CartProvider>(
                builder: (context, cart, child) {
                  double deliveryCharge = 0;
                  double taxFee=0.0;

                  (order.orderType ==
                      'delivery' &&
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .deliveryManagement
                          .status ==
                          0)
                      ? deliveryCharge =
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .deliveryCharge
                      : deliveryCharge = 0;
                  List<List<AddOns>> _addOnsList = [];
                  List<bool> _availableList = [];
                  double _itemPrice = 0;
                  double _discount = 0;
                  double _tax = 0;
                  double _addOns = 0;
                  cart.cartList.forEach((cartModel) {
                    List<AddOns> _addOnList = [];
                    cartModel.addOnIds.forEach((addOnId) {
                      for (AddOns addOns in cartModel.product.addOns) {
                        if (addOns.id == addOnId.id) {
                          _addOnList.add(addOns);
                          break;
                        }
                      }
                    });
                    _addOnsList.add(_addOnList);

                    _availableList.add(DateConverter.isAvailable(
                        cartModel.product.availableTimeStarts,
                        cartModel.product.availableTimeEnds,
                        context));

                    for (int index = 0; index < _addOnList.length; index++) {
                      _addOns = _addOns +
                          (_addOnList[index].price *
                              cartModel.addOnIds[index].quantity);
                    }
                    _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
                    _discount =
                        _discount + (cartModel.discountAmount * cartModel.quantity);
                    _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
                  });
                  cart.cateringList.forEach((element) {
                    _itemPrice = _itemPrice + (element.discountAmount * element.quantity);

                  });
                  cart.happyHoursList.forEach((element) {
                    _itemPrice = _itemPrice + (element.discountAmount * element.quantity);

                  });
                  cart.dealsList.forEach((element) {
                    _itemPrice = _itemPrice + (element.price * element.quantity);

                  });
                  double _subTotal = _itemPrice + _tax + _addOns;
                  double _total = _subTotal -
                      _discount -
                      Provider.of<CouponProvider>(context).discount +
                      deliveryCharge;
                  print('==tax fee:${Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .texFee}');


                  taxFee = (Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .texFee/100)*_total;
                  cart.taxFee=taxFee;

                  cart.deliveryCharge=deliveryCharge;
                  double _totalWithoutDeliveryFee = _subTotal -
                      _discount -
                      Provider.of<CouponProvider>(context).discount;

                  double _orderAmount = _itemPrice + _addOns;

                  bool _kmWiseCharge =
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .deliveryManagement
                          .status ==
                          1;
                  _total=_total+taxFee;

                  return cart.cartList.length > 0||cart.cateringList.length>0||cart.happyHoursList.length>0||cart.dealsList.length>0
                      ? Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight:
                                          !ResponsiveHelper.isDesktop(
                                              context) &&
                                              _height < 600
                                              ? _height
                                              : _height - 400),
                                      child: SizedBox(
                                        width: 1170,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: Dimensions
                                                      .PADDING_SIZE_LARGE),
                                                  child: Wrap(
                                                    children: [

                                                      if (ResponsiveHelper.isDesktop(
                                                          context))
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_LARGE,
                                                          ),
                                                          child: CartListWidget(
                                                              cart: cart,
                                                              addOns: _addOnsList,
                                                              availableList:
                                                              _availableList),
                                                        ),
                                                      if (ResponsiveHelper.isDesktop(
                                                          context))
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_LARGE,
                                                          ),
                                                          child: CartListWidget(
                                                              cart: cart,
                                                              isFromCatering: true,
                                                              addOns: _addOnsList,
                                                              availableList:
                                                              _availableList),
                                                        ),
                                                      if (ResponsiveHelper.isDesktop(
                                                          context))
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_LARGE,
                                                          ),
                                                          child: CartListWidget(
                                                              cart: cart,
                                                              isFromHappyHour: true,
                                                              addOns: _addOnsList,
                                                              availableList:
                                                              _availableList),
                                                        ),


                                                      if (ResponsiveHelper.isDesktop(
                                                          context))
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_LARGE,
                                                          ),
                                                          child: CartListWidget(
                                                              cart: cart,
                                                              isDeal: true,
                                                              addOns: _addOnsList,
                                                              availableList:
                                                              _availableList),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            if (ResponsiveHelper.isDesktop(
                                                context))
                                              SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_LARGE),
                                            Expanded(
                                              child: Container(
                                                decoration: ResponsiveHelper
                                                    .isDesktop(context)
                                                    ? BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: ColorResources
                                                            .CARD_SHADOW_COLOR
                                                            .withOpacity(
                                                            0.2),
                                                        blurRadius: 10,
                                                      )
                                                    ])
                                                    : BoxDecoration(),
                                                margin: ResponsiveHelper
                                                    .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_SMALL,
                                                    vertical: Dimensions
                                                        .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.all(0),
                                                padding: ResponsiveHelper
                                                    .isDesktop(context)
                                                    ? EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_LARGE,
                                                    vertical: Dimensions
                                                        .PADDING_SIZE_LARGE)
                                                    : EdgeInsets.all(0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      // Product
                                                      if (!ResponsiveHelper
                                                          .isDesktop(context))
                                                        CartListWidget(
                                                            cart: cart,
                                                            addOns: _addOnsList,
                                                            availableList:
                                                            _availableList),

                                                      // Coupon
                                                      if (!ResponsiveHelper
                                                          .isDesktop(context))
                                                        CartListWidget(
                                                            cart: cart,
                                                            isFromCatering: true,
                                                            addOns: _addOnsList,
                                                            availableList:
                                                            _availableList),
                                                      if (!ResponsiveHelper
                                                          .isDesktop(context))
                                                        CartListWidget(
                                                            cart: cart,
                                                            isFromHappyHour: true,
                                                            addOns: _addOnsList,
                                                            availableList:
                                                            _availableList),
                                                      if (!ResponsiveHelper
                                                          .isDesktop(context))
                                                        CartListWidget(
                                                            cart: cart,
                                                            isDeal: true,
                                                            addOns: _addOnsList,
                                                            availableList:
                                                            _availableList),
                                                      SizedBox(height: 10,),
                                                      ResponsiveHelper
                                                          .isDesktop(
                                                          context)
                                                          ? Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0,
                                                                20,
                                                                0,
                                                                20),
                                                            child: Text(
                                                                'People also like',
                                                                style: rubikMedium.copyWith(
                                                                    fontSize: Dimensions
                                                                        .FONT_SIZE_LARGE)),
                                                          ),
                                                        ],
                                                      )
                                                          : TitleWidget(
                                                        title:
                                                        'People also like',
                                                      ),
                                                      ProductView(
                                                        productType: ProductType
                                                            .POPULAR_PRODUCT,
                                                        isFromCart: true,
                                                      ),
                                                      // Order type
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE),
                                                      Consumer<CouponProvider>(
                                                        builder: (context,
                                                            coupon, child) {
                                                          return Row(children: [
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                _couponController,
                                                                style:
                                                                rubikRegular,
                                                                decoration:
                                                                InputDecoration(
                                                                  hintText: getTranslated(
                                                                      'enter_promo_code',
                                                                      context),
                                                                  hintStyle: rubikRegular
                                                                      .copyWith(
                                                                      color:
                                                                      ColorResources.getHintColor(context)),
                                                                  isDense: true,
                                                                  filled: true,
                                                                  enabled: coupon
                                                                      .discount ==
                                                                      0,
                                                                  fillColor: Theme.of(
                                                                      context)
                                                                      .cardColor,
                                                                  border:
                                                                  OutlineInputBorder(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .horizontal(
                                                                      left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false)
                                                                          .isLtr
                                                                          ? 10
                                                                          : 0),
                                                                      right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false)
                                                                          .isLtr
                                                                          ? 0
                                                                          : 10),
                                                                    ),
                                                                    borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                if (_couponController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                    !coupon
                                                                        .isLoading) {
                                                                  if (coupon
                                                                      .discount <
                                                                      1) {
                                                                    coupon
                                                                        .applyCoupon(
                                                                        _couponController
                                                                            .text,
                                                                        _total,
                                                                        context)
                                                                        .then(
                                                                            (discount) {
                                                                          if (discount >
                                                                              0) {
                                                                            showCustomSnackBar(
                                                                                'You got ${PriceConverter.convertPrice(context, discount)} discount',
                                                                                context,
                                                                                isError:
                                                                                false);
                                                                          } else {
                                                                            showCustomSnackBar(
                                                                                getTranslated('invalid_code_or',
                                                                                    context),
                                                                                context,
                                                                                isError:
                                                                                true);
                                                                          }
                                                                        });
                                                                  } else {
                                                                    coupon.removeCouponData(
                                                                        true);
                                                                  }
                                                                } else if (_couponController
                                                                    .text
                                                                    .isEmpty) {
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'enter_a_Coupon_code',
                                                                          context),
                                                                      context);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: 100,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                decoration:
                                                                BoxDecoration(
                                                                  color: Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .horizontal(
                                                                    left: Radius.circular(
                                                                        Provider.of<LocalizationProvider>(context, listen: false).isLtr
                                                                            ? 0
                                                                            : 10),
                                                                    right: Radius.circular(
                                                                        Provider.of<LocalizationProvider>(context, listen: false).isLtr
                                                                            ? 10
                                                                            : 0),
                                                                  ),
                                                                ),
                                                                child: coupon
                                                                    .discount <=
                                                                    0
                                                                    ? !coupon
                                                                    .isLoading
                                                                    ? Text(
                                                                  getTranslated('apply',
                                                                      context),
                                                                  style:
                                                                  rubikMedium.copyWith(color: Colors.white),
                                                                )
                                                                    : CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors
                                                                        .white))
                                                                    : Icon(
                                                                    Icons
                                                                        .clear,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ]);
                                                        },
                                                      ),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_LARGE),


                                                      TipView(isFromCart: true,orderAmount: _total,),
                                                      Text(
                                                          getTranslated(
                                                              'delivery_option',
                                                              context),
                                                          style: rubikMedium.copyWith(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_LARGE)),
                                                      Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                          .configModel
                                                          .homeDelivery
                                                          ? Row(
                                                        children: [
                                                          Provider.of<SplashProvider>(
                                                              context,
                                                              listen:
                                                              false)
                                                              .configModel
                                                              .homeDelivery
                                                              ? DeliveryOptionButton(
                                                              value:
                                                              'delivery',
                                                              title: getTranslated(
                                                                  'delivery',
                                                                  context),
                                                              kmWiseFee:
                                                              _kmWiseCharge)
                                                              : Padding(
                                                            padding: const EdgeInsets.only(
                                                                left:
                                                                Dimensions.PADDING_SIZE_SMALL,
                                                                top: Dimensions.PADDING_SIZE_LARGE),
                                                            child:
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.remove_circle_outline_sharp,
                                                                  color: Theme.of(context).hintColor,
                                                                ),
                                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                Text(getTranslated('home_delivery_not_available', context),
                                                                    style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor)),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Provider.of<SplashProvider>(
                                                              context,
                                                              listen:
                                                              false)
                                                              .configModel
                                                              .selfPickup
                                                              ? DeliveryOptionButton(
                                                              value:
                                                              'take_away',
                                                              title: 'Pickup',
                                                              kmWiseFee:
                                                              _kmWiseCharge)
                                                              : Padding(
                                                            padding: const EdgeInsets.only(
                                                                left:
                                                                Dimensions.PADDING_SIZE_SMALL,
                                                                bottom: Dimensions.PADDING_SIZE_LARGE),
                                                            child:
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.remove_circle_outline_sharp,
                                                                  color: Theme.of(context).hintColor,
                                                                ),
                                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                Text(getTranslated('self_pickup_not_available', context),
                                                                    style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                          : Column(
                                                        children: [
                                                          Provider.of<SplashProvider>(
                                                              context,
                                                              listen:
                                                              false)
                                                              .configModel
                                                              .homeDelivery
                                                              ? DeliveryOptionButton(
                                                              value:
                                                              'delivery',
                                                              title: getTranslated(
                                                                  'delivery',
                                                                  context),
                                                              kmWiseFee:
                                                              _kmWiseCharge)
                                                              : Padding(
                                                            padding: const EdgeInsets.only(
                                                                left:
                                                                Dimensions.PADDING_SIZE_SMALL,
                                                                top: Dimensions.PADDING_SIZE_LARGE),
                                                            child:
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.remove_circle_outline_sharp,
                                                                  color: Theme.of(context).hintColor,
                                                                ),
                                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                Text(getTranslated('home_delivery_not_available', context),
                                                                    style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor)),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Provider.of<SplashProvider>(
                                                              context,
                                                              listen:
                                                              false)
                                                              .configModel
                                                              .selfPickup
                                                              ? DeliveryOptionButton(
                                                              value:
                                                              'take_away',
                                                              title: getTranslated(
                                                                  'take_away',
                                                                  context),
                                                              kmWiseFee:
                                                              _kmWiseCharge)
                                                              : Padding(
                                                            padding: const EdgeInsets.only(
                                                                left:
                                                                Dimensions.PADDING_SIZE_SMALL,
                                                                bottom: Dimensions.PADDING_SIZE_LARGE),
                                                            child:
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.remove_circle_outline_sharp,
                                                                  color: Theme.of(context).hintColor,
                                                                ),
                                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                                                Text(getTranslated('self_pickup_not_available', context),
                                                                    style: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      // Total
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    'items_price',
                                                                    context),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                    fontSize:
                                                                    Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                                PriceConverter
                                                                    .convertPrice(
                                                                    context,
                                                                    _itemPrice),
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                    fontSize:
                                                                    Dimensions.FONT_SIZE_LARGE)),
                                                          ]),
                                                      SizedBox(height: 10),

                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Fee & Estimated Tax',
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                    fontSize:
                                                                    Dimensions.FONT_SIZE_LARGE)),
                                                            Text(
                                                                ' ${PriceConverter.convertPrice(context, taxFee)}',
                                                                style: rubikRegular
                                                                    .copyWith(
                                                                    fontSize:
                                                                    Dimensions.FONT_SIZE_LARGE)),
                                                          ]),

                                                      /// addons
                                                      // SizedBox(height: 10),
                                                      //
                                                      // Row(
                                                      //     mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      //     children: [
                                                      //       Text(
                                                      //           getTranslated(
                                                      //               'addons',
                                                      //               context),
                                                      //           style: rubikRegular
                                                      //               .copyWith(
                                                      //               fontSize:
                                                      //               Dimensions.FONT_SIZE_LARGE)),
                                                      //       Text(
                                                      //           ' ${PriceConverter.convertPrice(context, _addOns)}',
                                                      //           style: rubikRegular
                                                      //               .copyWith(
                                                      //               fontSize:
                                                      //               Dimensions.FONT_SIZE_LARGE)),
                                                      //     ]),
                                                      ///discount
                                                      // SizedBox(height: 10),
                                                      //
                                                      // Row(
                                                      //     mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .spaceBetween,
                                                      //     children: [
                                                      //       Text(
                                                      //           getTranslated(
                                                      //               'discount',
                                                      //               context),
                                                      //           style: rubikRegular
                                                      //               .copyWith(
                                                      //                   fontSize:
                                                      //                       Dimensions.FONT_SIZE_LARGE)),
                                                      //       Text(
                                                      //           '- ${PriceConverter.convertPrice(context, _discount)}',
                                                      //           style: rubikRegular
                                                      //               .copyWith(
                                                      //                   fontSize:
                                                      //                       Dimensions.FONT_SIZE_LARGE)),
                                                      //     ]),
                                                      SizedBox(height: 10),
                                                      Obx(() =>   tipController.isNotTip.value
                                                          ? SizedBox()
                                                          : Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Staff Tip',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize:
                                                                  Dimensions.FONT_SIZE_LARGE),
                                                            ),
                                                            Obx(() =>  Text(
                                                              '\$${tipController.tip.value.toStringAsFixed(2)}',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize:
                                                                  Dimensions.FONT_SIZE_LARGE),
                                                            ),)
                                                          ]).marginOnly(bottom: 10),),

                                                      //
                                                      // Provider.of<CouponProvider>(
                                                      //     context)
                                                      //     .discount !=
                                                      //     0.0
                                                      //     ? Row(
                                                      //     mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      //     children: [
                                                      //       Text(
                                                      //           getTranslated(
                                                      //               'coupon_discount',
                                                      //               context),
                                                      //           style: rubikRegular.copyWith(
                                                      //               fontSize:
                                                      //               Dimensions.FONT_SIZE_LARGE)),
                                                      //       Text(
                                                      //         '- ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                                      //         style: rubikRegular.copyWith(
                                                      //             fontSize:
                                                      //             Dimensions.FONT_SIZE_LARGE),
                                                      //       ),
                                                      //     ])
                                                      //     : SizedBox(),
                                                      // Provider.of<CouponProvider>(
                                                      //     context)
                                                      //     .discount !=
                                                      //     0.0
                                                      //     ? SizedBox(height: 10)
                                                      //     : SizedBox(),

                                                      _kmWiseCharge
                                                          ? SizedBox()
                                                          : Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              getTranslated(
                                                                  'delivery_fee',
                                                                  context),
                                                              style: rubikRegular.copyWith(
                                                                  fontSize:
                                                                  Dimensions.FONT_SIZE_LARGE),
                                                            ),
                                                            Text(
                                                              ' ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                                              style: rubikRegular.copyWith(
                                                                  fontSize:
                                                                  Dimensions.FONT_SIZE_LARGE),
                                                            ),
                                                          ]),

                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: Dimensions
                                                                .PADDING_SIZE_SMALL),
                                                        child: CustomDivider(),
                                                      ),

                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                                getTranslated(
                                                                    _kmWiseCharge
                                                                        ? 'subtotal'
                                                                        : 'total_amount',
                                                                    context),
                                                                style: rubikMedium
                                                                    .copyWith(
                                                                  fontSize:
                                                                  Dimensions
                                                                      .FONT_SIZE_EXTRA_LARGE,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .primaryColor,
                                                                )),
                                                            Obx(() =>   Text(
                                                              PriceConverter
                                                                  .convertPrice(
                                                                  context,
                                                                  _total+ double.parse(tipController.tip.value.toString())),
                                                              style: rubikMedium.copyWith(
                                                                  fontSize:
                                                                  Dimensions
                                                                      .FONT_SIZE_EXTRA_LARGE,
                                                                  color: Theme.of(
                                                                      context)
                                                                      .primaryColor),
                                                            ),)
                                                          ]),
                                                      if (ResponsiveHelper
                                                          .isDesktop(context))
                                                        SizedBox(
                                                            height: Dimensions
                                                                .PADDING_SIZE_DEFAULT),
                                                      if (ResponsiveHelper
                                                          .isDesktop(context))
                                                        Container(
                                                          width: 1170,
                                                          padding: EdgeInsets
                                                              .all(Dimensions
                                                              .PADDING_SIZE_SMALL),
                                                          child: CustomButton(
                                                              btnTxt: getTranslated(
                                                                  'continue_checkout',
                                                                  context),
                                                              onTap: () {
                                                                if (_orderAmount <
                                                                    Provider.of<SplashProvider>(context,
                                                                        listen: false)
                                                                        .configModel
                                                                        .minimumOrderValue) {
                                                                  showCustomSnackBar(
                                                                      'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.',
                                                                      context);
                                                                } else {
                                                                  Provider.of<LocationProvider>(context,
                                                                      listen: false)
                                                                      .initAddressList(context)
                                                                      .then((value) {
                                                                    if (Provider.of<LocationProvider>(context,
                                                                        listen: false)
                                                                        .addressList
                                                                        .length <=
                                                                        0&&Provider.of<OrderProvider>(context,
                                                                        listen: false)
                                                                        .orderType=='delivery') {
                                                                      print('===order type1:${Provider.of<OrderProvider>(context,
                                                                          listen: false)
                                                                          .orderType}');
                                                                      _checkPermission(
                                                                          context,
                                                                          Routes.getAddAddressRoute(
                                                                              'cart', 'add', AddressModel(),
                                                                              amount:
                                                                              _total+double.parse(tipController.tip.value.toString())));
                                                                    } else {
                                                                      print('===order type:${Provider.of<OrderProvider>(context,
                                                                          listen: false)
                                                                          .orderType}');
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          Routes.getCheckoutRoute(
                                                                            _total+double.parse(tipController.tip.value.toString()),
                                                                            'cart',
                                                                            Provider.of<OrderProvider>(context,
                                                                                listen: false)
                                                                                .orderType,
                                                                            Provider.of<CouponProvider>(context,
                                                                                listen: false)
                                                                                .code,
                                                                          ));
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                          ),
                                                        ),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  FooterView(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!ResponsiveHelper.isDesktop(context))
                        Container(
                          width: 1170,
                          padding:
                          EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: CustomButton(
                              btnTxt:
                              getTranslated('continue_checkout', context),
                              onTap: () {
                                if (_orderAmount <
                                    Provider.of<SplashProvider>(context,
                                        listen: false)
                                        .configModel
                                        .minimumOrderValue) {
                                  showCustomSnackBar(
                                      'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.',
                                      context);
                                } else {
                                  Provider.of<LocationProvider>(context,
                                      listen: false)
                                      .initAddressList(context)
                                      .then((value) {
                                    if (Provider.of<LocationProvider>(context,
                                        listen: false)
                                        .addressList
                                        .length <=
                                        0&&Provider.of<OrderProvider>(context,
                                        listen: false)
                                        .orderType=='delivery') {
                                      _checkPermission(
                                          context,
                                          Routes.getAddAddressRoute(
                                              'cart', 'add', AddressModel(),
                                              amount:
                                              _total+double.parse(tipController.tip.value.toString())));
                                    } else {
                                      Navigator.pushNamed(
                                          context,
                                          Routes.getCheckoutRoute(
                                            _total+double.parse(tipController.tip.value.toString()),
                                            'cart',
                                            Provider.of<OrderProvider>(context,
                                                listen: false)
                                                .orderType,
                                            Provider.of<CouponProvider>(context,
                                                listen: false)
                                                .code,
                                          ));
                                    }
                                  });
                                }
                              }),
                        ),
                    ],
                  )
                      : NoDataScreen(isCart: true);
                },
              );
            });



      }),
    );
  }

  void _checkPermission(BuildContext context, String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PermissionDialog());
    } else {
      Navigator.pushNamed(context, navigateTo);
    }
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  final bool isFromCatering;
  final bool isFromHappyHour;
  final bool isDeal;

  const CartListWidget(
      {Key key,
        @required this.cart,
        @required this.addOns,
        @required this.availableList,
        this.isFromCatering=false,
        this.isFromHappyHour=false,
        this.isDeal=false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('===length:${cart.dealsList}');
    return isDeal?ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:cart.dealsList.length,
      itemBuilder: (context, index) {

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),          decoration: BoxDecoration(
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
          child: ExpansionTile(
            textColor: Theme.of(context).primaryColor,
            iconColor: Theme.of(context).primaryColor,
            childrenPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder_image,
                height: 70,
                width: 85,
                fit: BoxFit.cover,
                image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.offerUrl}/${cart.dealsList[index].deal.image}',
                imageErrorBuilder: (c, o, s) => Image.asset(
                    Images.placeholder_image,
                    height: 70,
                    width: 85,
                    fit: BoxFit.cover),
              ),
            ),

            title:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cart.dealsList[index].deal.name,
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
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Text(
                  //         'No of Items : ${cart.dealsList[index].deal.dealItems.length}',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 14
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 5),

                  Row(children: [
                    Flexible(
                      child: Text(
                        '${PriceConverter.convertPrice(context,
                            cart.dealsList[index].price ?? 0.0)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15
                        ),

                      ),
                    ),
                  ]),
                ]),
            trailing:   Container(
              width: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Provider.of<CouponProvider>(context, listen: false)
                        .removeCouponData(true);
                    if (cart.dealsList[index].quantity > 1) {
                      Provider.of<CartProvider>(context, listen: false)
                          .setQuantity(
                          isIncrement: false,
                          fromProductView: false,
                          isCart: false,
                          isHappyHours: false,
                          isDeal: true,
                          dealCartModel: cart.dealsList[index],
                          productIndex: null);
                    } else {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeFromCart(index,
                          isCatering: false,
                          isCart: false,
                          isDeal: true,
                          isHappyHours: false);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.remove, size: 20),
                  ),
                ),
                Text(cart.dealsList[index].quantity.toString(),
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
                        isHappyHours: false,
                        isDeal: true,
                        dealCartModel: cart.dealsList[index],
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

            children: [
              for ( var deal in cart.dealsList[index].deal.dealItems ) Container(
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
                  Container(
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
                                  height: 50,
                                  width: 65,
                                  fit: BoxFit.cover,
                                  image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${deal.image}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholder_image,
                                      height: 50,
                                      width: 65,
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
                                  Text(deal.name,
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
                                          'Quantity : ${deal.itemQuantity}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),


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
                ]),
              )
            ],
          ),
        );
      },
    ): ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:isFromCatering?cart.cateringList.length:isFromHappyHour?cart.happyHoursList.length: cart.cartList.length,
      itemBuilder: (context, index) {

        return isFromCatering?CartOfferWidget(cartIndex: index,cateringCartModel: cart.cateringList[index],):isFromHappyHour?CartHappyHourWidget(cartIndex: index,happyHoursCartModel: cart.happyHoursList[index],):CartProductWidget(
            cart:isFromCatering?null: cart.cartList[index],
            cartIndex: index,


            addOns:isFromCatering?null: addOns[index],
            isAvailable: availableList[index]);
      },
    );
  }
}
