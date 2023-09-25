import 'package:flutter/material.dart';

import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';

import 'package:flutter_restaurant/utill/dimensions.dart';

import 'package:flutter_restaurant/view/base/custom_button.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/response/offer_model.dart';

import '../../../../utill/routes.dart';

import 'buffet_sheet_view.dart';
import 'catering_sheet_view.dart';
import 'happy_hours_sheet.dart';

class SpecialOffersBottomSheet extends StatefulWidget {
  SpecialOfferModel specialOfferModel;

  SpecialOffersBottomSheet({@required this.specialOfferModel});

  @override
  State<SpecialOffersBottomSheet> createState() =>
      _SpecialOffersBottomSheetState();
}

class _SpecialOffersBottomSheetState extends State<SpecialOffersBottomSheet> {
  int _cartIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      _cartProvider.setCartUpdate(false);
      return Stack(
        children: [
          Container(
            width: 600,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile(context)
                  ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20))
                  : BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.isMobile(context)
                        ? Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )
                        : SizedBox(),
                    widget.specialOfferModel.type == 'buffet'
                        ? BuffeeSheetView(
                      specialOfferModel: widget.specialOfferModel,
                    )
                        : SizedBox.shrink(),
                    widget.specialOfferModel.type == 'catering'
                        ? CateringSheetView(
                      specialOfferModel: widget.specialOfferModel,
                    )
                        : SizedBox.shrink(),
                    widget.specialOfferModel.type == 'happyhour'
                        ? HapyyHoursSheetView(
                      specialOfferModel: widget.specialOfferModel,
                    )
                        : SizedBox.shrink(),
                    // widget.specialOfferModel.type == 'happyhour'
                    //     ? GroupOrderSheetView()
                    //     : SizedBox.shrink(),
                    SizedBox(
                      height: 8,
                    ),
                    widget.specialOfferModel.type == 'buffet'
                        ? CustomButton(
                        btnTxt: 'Book Now',
                        // btnTxt:ResponsiveHelper.isDesktop(context)?'Send Message For Booking':'Call Now For Booking',
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: () {
                          if (ResponsiveHelper.isDesktop(context)) {
                            Navigator.pushNamed(context,
                                Routes.getChatRoute(orderModel: null));
                          } else {
                            launchUrl(Uri.parse(
                                'tel:${Provider.of<SplashProvider>(context, listen: false).configModel.restaurantPhone}'));
                          }
                        })
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile(context)
              ? SizedBox()
              : Positioned(
            right: 10,
            top: 5,
            child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close)),
          ),
        ],
      );
    });
  }
}
