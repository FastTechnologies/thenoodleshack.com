import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../helper/responsive_helper.dart';
import '../../../provider/product_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/custom_text_field.dart';

class TipView extends StatefulWidget {
  bool isFromCart;
  double orderAmount;
   TipView({Key key,this.isFromCart=false,this.orderAmount=0.0}) : super(key: key);

  @override
  State<TipView> createState() => _TipViewState();
}

class _TipViewState extends State<TipView> {
  final tipController=Get.put(TipController());
  @override
  void initState() {
    Future.delayed(Duration(microseconds: 100)).then((value) {
      tipController.initialData(widget.isFromCart,orderAmount: widget.orderAmount);
      tipController.controller.clear();
    });


    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //tipController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isFromCart?'Tip the crew': 'Rider Tip',
            style:widget.isFromCart?rubikMedium.copyWith(
                fontSize: Dimensions
                    .FONT_SIZE_LARGE): rubikMedium.copyWith(
                color: ColorResources.getGreyBunkerColor(context)),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          SizedBox(
            height: ResponsiveHelper.isMobile(context)?45:70,
            child: ListView.builder(
              itemCount:widget.isFromCart?tipController.tipPercentList.length: tipController.tipsAmountList.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    tipController. isNotTip.value = false;

                    tipController.updateTip(i,widget.isFromCart,orderAmount: widget.orderAmount);

                  },
                  child: Container(
                    width: ResponsiveHelper.isMobile(context)?70:100,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: ColorResources.getSearchBg(context),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: tipController.selectedTip
                                .contains(tipController.tipsAmountList[i])||tipController.selectedTip
                                .contains(tipController.tipPercentList[i])
                                ? Theme.of(context).textTheme.bodyText1.color
                                : Colors.transparent)),
                    child:widget.isFromCart?Text(
                      i != 3
                          ? '${tipController.tipPercentList[i]}%'
                          : '${tipController.tipPercentList[i]}',
                      style: rubikMedium.copyWith(
                          color: ColorResources.getGreyBunkerColor(context),
                      fontSize: ResponsiveHelper.isMobile(context)?Dimensions.FONT_SIZE_DEFAULT:Dimensions.FONT_SIZE_EXTRA_LARGE
                      ),
                      overflow: TextOverflow.ellipsis,
                    ): Text(
                      i != 3
                          ? '${tipController.tipsAmountList[i]}\$'
                          : '${tipController.tipsAmountList[i]}',
                      style: rubikMedium.copyWith(
                          color: ColorResources.getGreyBunkerColor(context),
                          fontSize: ResponsiveHelper.isMobile(context)?Dimensions.FONT_SIZE_DEFAULT:Dimensions.FONT_SIZE_EXTRA_LARGE

                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          tipController.selectedTip.contains('Other')
              ? Row(
            children: [
              Text(
                'Enter amount in \$ : ',
                style: rubikMedium.copyWith(
                    color: ColorResources.getGreyBunkerColor(context)),
                overflow: TextOverflow.ellipsis,
              ),

             ResponsiveHelper.isMobile(context)? Expanded(
               // width: 60,
               //height: 50,
               child: CustomTextField(
                 maxLines: 1,
                 capitalization: TextCapitalization.sentences, controller: tipController.controller,
                 inputType: TextInputType.number,
                 onChanged: (val) {
                   print('==${val.runtimeType}');
                   if (val == null || val == '') {
                     tipController.tip.value = 0.0;
                   } else {

                     tipController.tip.value = double.parse(val);

                   }
                 },
                 hintText: '0',
                 inputDecoration: InputDecoration(
                   contentPadding:
                   EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                   isDense: true,
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5),
                       borderSide: BorderSide(color: Colors.black)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5),
                       borderSide: BorderSide(color: Colors.black)),
                 ),
               ),
             ): SizedBox(
               width: 100,

               child: CustomTextField(
                 maxLines: 1,
                 capitalization: TextCapitalization.sentences, controller: tipController.controller,
                 inputType: TextInputType.number,
                 onChanged: (val) {
                   print('==${val.runtimeType}');
                   if (val == null || val == '') {
                     tipController.tip.value = 0.0;
                   } else {

                     tipController.tip.value = double.parse(val);

                   }
                 },
                 hintText: '0',
                 inputDecoration: InputDecoration(
                   contentPadding:
                   EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                   isDense: true,
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5),
                       borderSide: BorderSide(color: Colors.black)),
                   focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5),
                       borderSide: BorderSide(color: Colors.black)),
                 ),
               ),
             )

            ],
          )
              : SizedBox.shrink(),
          Row(
            children: [
              Checkbox(
                  activeColor: Theme.of(context).primaryColor,
                  value: tipController.isNotTip.value,
                  onChanged: (val) {
                    setState(() {
                      tipController.isNotTip.toggle();
                      if (tipController.isNotTip.value) {
                        tipController.tip.value=0.0;
                        tipController.selectedTip.clear();
                      }else{

                      }
                    });
                  }),
              Text(
                'I don\'t wanna pay tip',
                style: rubikMedium.copyWith(
                    color: Colors.red, fontWeight: FontWeight.w200),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ));
    });
  }
}
