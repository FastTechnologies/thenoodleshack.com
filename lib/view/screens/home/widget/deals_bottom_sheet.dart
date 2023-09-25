import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/deals_data_model.dart';

import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';

import 'package:flutter_restaurant/utill/dimensions.dart';


import 'package:provider/provider.dart';

import '../../../../data/model/response/offer_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/app_toast.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/images.dart';
import '../../../../utill/routes.dart';
import '../../../../utill/styles.dart';
import '../../../base/custom_button.dart';


class DealsBottomSheet extends StatefulWidget {
  DealsDataModel dealsDataModel;

  DealsBottomSheet({@required this.dealsDataModel});

  @override
  State<DealsBottomSheet> createState() =>
      _DealsBottomSheetState();
}

class _DealsBottomSheetState extends State<DealsBottomSheet> {
  int _cartIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, _cartProvider, child) {
      _cartProvider.setCartUpdate(false);
      String _productImage = '';
      try{
        _productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.dealsDataModel.image}';
      }catch(e) {

      }
      int _cartIndex =   _cartProvider.getCarDealIndex(widget.dealsDataModel);
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

                    Text('${widget.dealsDataModel.name}',
                        style:
                        rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Deal Ends At:',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          '${DateConverter.estimatedDate(widget.dealsDataModel.expireDate)}',
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
                          'Discount:',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          '${widget.dealsDataModel.discountPercentage}%',
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
                          'Total price:',
                          style: rubikMedium.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          '${widget.dealsDataModel.totalDiscountAmount}',
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
                    Text('Deal Items',
                        style:
                        rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(
                      height: 185,

                      child: ListView.builder(
                          itemCount: widget.dealsDataModel.dealItems.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            return Container(
                              // height: 180 ,
                              margin:  EdgeInsets.only(
                                  top: 8.0, left: index == 0 ? 0 : 8, right: 6, bottom: 8),
                              width: 100,
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
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.dealsDataModel.dealItems[index].image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(
                                            Images.placeholder_rectangle,
                                            fit: BoxFit.cover,
                                            height: 90,
                                            width: 150),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Text(
                                                '${widget.dealsDataModel.dealItems[index].name}',
                                                style: rubikBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL),
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Quantity : ${widget.dealsDataModel.dealItems[index].itemQuantity}',
                                                style: rubikBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,fontWeight: FontWeight.w500),
                                              ),



                                            ]),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 8,
                                    )
                                  ]),
                            );
                          }),
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    CustomButton(
                        btnTxt: 'Add to cart',
                        // btnTxt:ResponsiveHelper.isDesktop(context)?'Send Message For Booking':'Call Now For Booking',
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: () {
                          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {

                            DealCartModel dealModle = DealCartModel(double.parse(widget.dealsDataModel.totalDiscountAmount), 0.0,
                                0.0, 1, widget.dealsDataModel);

                            if (!_cartProvider.dealsList
                                .map((e) => e.deal.id)
                                .contains(widget.dealsDataModel.id)) {
                              _cartProvider.addDealToCart(dealModle, _cartIndex);
                              Navigator.pop(context);

                              appToast(text: 'Deal added to cart',toastColor: Colors.green);
                            } else {
                              Provider.of<CartProvider>(context, listen: false).setQuantity(
                                  isIncrement: true,
                                  fromProductView: false,
                                  isCatering: false,
                                  isCart: false,
                                  isDeal: true,
                                  dealCartModel: _cartProvider.dealsList
                                      .where((element) =>
                                  element.deal.id == widget.dealsDataModel.id)
                                      .toList()[0],
                                  productIndex: null);
                              Navigator.pop(context);

                              appToast(text: 'Deal added ${_cartProvider.dealsList.where((element) => element.deal.id==widget.dealsDataModel.id).toList()[0].quantity.toString()} times',toastColor: Colors.green);

                              //appToast(text: 'Item added ${ _cartProvider.cartList.where((element) => element.product.id==product.id).toList()[0].quantity.toString()} times!',toastColor: Colors.green);
                            }



                          } else {
                            Navigator.pushNamed(context, Routes.getLoginRoute());

                            //  appToast(text: 'You need to login first');
                          }
                        }),
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
