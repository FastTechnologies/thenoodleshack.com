import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class ProductWidgetWebShimmer extends StatelessWidget {
  bool isFromCart;
  ProductWidgetWebShimmer({this.isFromCart=false});
  @override
  Widget build(BuildContext context) {
    print('====ProductWidgetWebShimmer');
    return Container(
        height:isFromCart? 180:null,
        width:isFromCart? 120:null,
        margin: EdgeInsets.only(

            right: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 300],
                blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
            ]),
        child: Shimmer(
          duration: Duration(seconds: 1), interval: Duration(seconds: 1),
          enabled: Provider
              .of<ProductProvider>(context)
              .popularProductList == null,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: isFromCart?80:105, width: isFromCart?100:195,
                decoration: BoxDecoration(borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10)), color: Colors.grey[300])),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Container(height: 15, color: Colors.grey[300])
                      ),
                      // RatingBar(
                      //     rating: 0.0, size:isFromCart?10: Dimensions.PADDING_SIZE_DEFAULT,),
                     isFromCart?SizedBox(): Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(height: Dimensions.PADDING_SIZE_SMALL, width: 30, color: Colors.grey[300]),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Container(height: Dimensions.PADDING_SIZE_SMALL, width: 30, color: Colors.grey[300]),
                          ],
                        ),
                      ),
                    isFromCart?SizedBox():  Container(height: 30, width: 150,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    ]),
              ),
            ),

          ]),
        )
    );
  }
}