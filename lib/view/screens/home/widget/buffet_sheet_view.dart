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

class BuffeeSheetView extends StatefulWidget {
  SpecialOfferModel specialOfferModel;

  BuffeeSheetView({Key key, this.specialOfferModel}) : super(key: key);

  @override
  State<BuffeeSheetView> createState() => _BuffeeSheetViewState();
}

class _BuffeeSheetViewState extends State<BuffeeSheetView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(
            ResponsiveHelper.isMobile(context)
                ? 0
                : Dimensions.PADDING_SIZE_EXTRA_LARGE),        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppConstants.APP_NAME} Buffet',
                  style:
                      rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              SizedBox(
                height: 8,
              ),
              Text('We provide best Buffet service onsite',
                  style: rubikMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.FONT_SIZE_SMALL)),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  itemCount: widget.specialOfferModel.buffet.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buffetDetailsView(context, index);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buffetDetailsView(BuildContext context, index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${widget.specialOfferModel.buffet[index].subType == 'lunch' ? 'Lunch' : 'Dinner'} Buffet',
              style:
                  rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          SizedBox(
            height: 8,
          ),
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
                '${DateConverter.getTime(widget.specialOfferModel.buffet[index].offerAvailableTimeStarts??"16:00")}',
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
                '${DateConverter.getTime(widget.specialOfferModel.buffet[index].offerAvailableTimeEnds??'16:00')}',
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
                'Price per person',
                style: rubikMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.FONT_SIZE_SMALL),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                PriceConverter.convertPrice(
                    context,
                    double.parse(widget.specialOfferModel.buffet[index].price
                        .toString())),
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
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              //   controller: scrollController,
              itemCount: widget.specialOfferModel.buffet[index].allItems.length,
              itemBuilder: (context, subIndex) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: subIndex == 0 ? 0 : 8, right: 6, bottom: 8),
                  child: SpecialOfferProductCard(
                    isBuffet: true,
                    offerProduct: widget
                        .specialOfferModel.buffet[index].allItems[subIndex],
                    specialOfferModel: widget.specialOfferModel.buffet[index],
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
        ]);
  }
}
