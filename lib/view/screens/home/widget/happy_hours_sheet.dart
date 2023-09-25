import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';

import 'package:flutter_restaurant/helper/responsive_helper.dart';

import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_offer_produtc_card.dart';

import 'package:provider/provider.dart';

import '../../../../helper/date_converter.dart';
import '../../../../helper/price_converter.dart';
import '../../../../utill/app_constants.dart';

class HapyyHoursSheetView extends StatefulWidget {
  SpecialOfferModel specialOfferModel;

  HapyyHoursSheetView({Key key, this.specialOfferModel}) : super(key: key);

  @override
  State<HapyyHoursSheetView> createState() => _HapyyHoursSheetViewState();
}

class _HapyyHoursSheetViewState extends State<HapyyHoursSheetView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(
            ResponsiveHelper.isMobile(context)
                ? 0
                : Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppConstants.APP_NAME} Happy Hours',
                  style:
                      rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              SizedBox(
                height: 8,
              ),
              Text('Come and Avail the deal at your convenience',
                  style: rubikMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              SizedBox(
                height: 8,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Start Time:',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          '${DateConverter.getTime(widget.specialOfferModel.offerAvailableTimeStarts)}',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'End Time:',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          '${DateConverter.getTime(widget.specialOfferModel.offerAvailableTimeEnds)}',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        //   controller: scrollController,
                        itemCount: widget.specialOfferModel.happyhour.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: 8.0,
                                left: index == 0 ? 0 : 8,
                                right: 6,
                                bottom: 8),
                            child: SpecialOfferProductCard(
                              isHappyHours: true,
                              specialOfferModel: widget.specialOfferModel,
                              offerProduct:
                                  widget.specialOfferModel.happyhour[index],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    //
                    // Text(
                    //     'Dinner Buffet',
                    //     style: rubikMedium.copyWith(
                    //         fontSize:
                    //         Dimensions.FONT_SIZE_LARGE)),
                    // SizedBox(height: 8,),
                    // Row(
                    //
                    //   children: [
                    //     Text(
                    //       'Start Time:',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     Spacer(),
                    //     Text(
                    //       '12:00',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 8,),
                    // Row(
                    //
                    //   children: [
                    //     Text(
                    //       'End Time:',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     Spacer(),
                    //     Text(
                    //       '12:00',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 8,),
                    // Row(
                    //
                    //   children: [
                    //     Text(
                    //       'Price per person',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     Spacer(),
                    //     Text(
                    //       '255',
                    //       style: rubikMedium.copyWith(
                    //           fontWeight: FontWeight.w400,
                    //
                    //           fontSize:
                    //           Dimensions.FONT_SIZE_SMALL),
                    //       maxLines: 2,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 8,),
                    // SizedBox(
                    //   height: 150,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     physics: BouncingScrollPhysics(),
                    //     //   controller: scrollController,
                    //     itemCount:5,
                    //     itemBuilder: (context, index) {
                    //       return Padding(
                    //         padding:  EdgeInsets.only(top: 8.0,left: index==0?0:8,right: 6,bottom: 8),
                    //         child: SpecialOfferProductCard(isBuffet: true,specialOfferModel: widget.specialOfferModel,),
                    //       );
                    //     },
                    //   ),
                    // ),
                    //Product
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
