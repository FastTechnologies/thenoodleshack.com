import 'package:flutter/material.dart';

import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';

import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_offer_card.dart';
import 'package:provider/provider.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';

class SpecialOffersView extends StatefulWidget {
  final ProductType productType;
  final ScrollController scrollController;
  bool isFromCart;
  bool isFromCartSheet;
  bool isBuffet;
  bool isFromPointsScreen;


  SpecialOffersView(
      {@required this.productType,
        this.scrollController,
        this.isFromCart = false,
        this.isBuffet=false,
        this.isFromPointsScreen=false,
        this.isFromCartSheet = false});

  @override
  State<SpecialOffersView> createState() => _SpecialOffersViewState();
}

class _SpecialOffersViewState extends State<SpecialOffersView> {
  bool _isLoggedIn;



  bool isShowArrow=true;
  final double _width = 50.0; // single item length
  final listLength = 20;
  final int baseScrollPoint = 3; // every click will move this much
  double scrollWidth = 0.0;
  int move = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }



  @override
  Widget build(BuildContext context) {
    final _productProvider =
    Provider.of<ProductProvider>(context, listen: false);

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {

        return _productProvider.specialofferList==null? SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: widget.isFromCart ? 120 : 195,
                  child: ProductWidgetWebShimmer(
                    isFromCart: widget.isFromCart,
                  ),
                );
              },
            ),
          ):SizedBox(
          height:  220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount:_productProvider.specialofferList.length,
            itemBuilder: (context, index) {
              return SpecialOfferCard(specialOfferModel:_productProvider.specialofferList[index] ,);
            },
          ),
        );




      },
    );
  }
}
