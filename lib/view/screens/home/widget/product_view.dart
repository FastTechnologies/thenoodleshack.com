import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_product_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../../base/title_widget.dart';

class ProductView extends StatefulWidget {
  final ProductType productType;
  final ScrollController scrollController;
  bool isFromCart;
  bool isFromCartSheet;
  bool isBuffet;
  bool isFromPointsScreen;


  ProductView(
      {@required this.productType,
      this.scrollController,
      this.isFromCart = false,
        this.isBuffet=false,
        this.isFromPointsScreen=false,
      this.isFromCartSheet = false});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  bool _isLoggedIn;



  ScrollController scrollController=ScrollController();
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
    if(widget.isFromPointsScreen){
      _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
      if(_isLoggedIn) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      }
    }
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
          isShowArrow=true;
          setState(() {

          });
        } else {
          setState(() {
            isShowArrow=false;

          });
          print('At the bottom:$isShowArrow');
        }
      }
    });

  }
  scrollToRight(){
    if(scrollWidth <= scrollController.offset){
      setState(() {
        scrollWidth = _width * baseScrollPoint * move;
        move++;
      });
      scrollController.animateTo(scrollWidth, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  scrollToLeft(){
    if(scrollWidth > 0){
      setState(() {
        move--;
        scrollWidth = scrollWidth - (baseScrollPoint* _width);
      });
      scrollController.animateTo(scrollWidth, duration: Duration(milliseconds:300), curve: Curves.fastOutSlowIn);
    }
  }


  @override
  Widget build(BuildContext context) {
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (!ResponsiveHelper.isDesktop(context) &&
        widget.productType == ProductType.LATEST_PRODUCT) {
      widget.scrollController?.addListener(() {
        if (widget.scrollController.position.pixels ==
                widget.scrollController.position.maxScrollExtent &&
            (_productProvider.latestProductList != null) &&
            !_productProvider.isLoading) {
          int pageSize;
          if (widget.productType == ProductType.LATEST_PRODUCT) {
            pageSize = (_productProvider.latestPageSize / 10).ceil();
          }
          if (_productProvider.latestOffset < pageSize) {
            _productProvider.latestOffset++;
            _productProvider.showBottomLoader();
            if (widget.productType == ProductType.LATEST_PRODUCT) {
              _productProvider.getLatestProductList(
                context,
                false,
                _productProvider.latestOffset.toString(),
                Provider.of<LocalizationProvider>(context, listen: false)
                    .locale
                    .languageCode,
              );
            }
          }
        }
      });
    }
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if (widget.productType == ProductType.LATEST_PRODUCT) {
          // productList = prodProvider.latestProductList;
          productList = prodProvider.latestProductList;
        } else if (widget.productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        } else if (widget.productType == ProductType.RELATED_PRODUCT) {
          productList = prodProvider.relatedProducts;
        }
        else if (widget.productType == ProductType.LOYALTY_PRODUCT) {
          productList = prodProvider.loyaltyPointsProducts;
        }
        else if (widget.productType == ProductType.RECOMMENDED_SIDES) {
          productList = prodProvider.recommendedSidesList;
        }
        else if (widget.productType == ProductType.RECOMMENDED_BEVERAGES) {
          productList = prodProvider.recommendedBeveragesList.reversed.toList();
        }
        if (productList == null) {
          return widget.productType == ProductType.POPULAR_PRODUCT ||
                  widget.productType == ProductType.RELATED_PRODUCT|| widget.productType == ProductType.LOYALTY_PRODUCT||
                  widget.productType == ProductType.RECOMMENDED_SIDES|| widget.productType == ProductType.RECOMMENDED_BEVERAGES
              ?widget.isFromCart? SizedBox(
                  height: widget.isFromCart ? 200 : 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                )
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing:
                    ResponsiveHelper.isMobile(context) ? 8 : 5,
                    mainAxisSpacing: 5,
                    childAspectRatio:
                    ResponsiveHelper.isMobile(context) ?widget.isFromPointsScreen?1.8: 2.1 : 4,
                    crossAxisCount:
                    ResponsiveHelper.isTab(context) ? 2 : 2,
                        ),
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) {
                    return  ProductShimmer(isEnabled: productList == null);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                ):SizedBox();
        }
        if (productList == null) {
          return SizedBox();
        }

        return widget.productType == ProductType.POPULAR_PRODUCT ||
                widget.productType == ProductType.RELATED_PRODUCT||
                widget.productType == ProductType.LOYALTY_PRODUCT||
            widget.productType == ProductType.RECOMMENDED_SIDES|| widget.productType == ProductType.RECOMMENDED_BEVERAGES

            ?widget.isFromCart?            Row(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: widget.isFromCart ? 200 : 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: widget.isFromCart
                          ? productList.length
                          : productList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: widget.isFromCart && index == 0 ? 0 : 10,
                              right: 5,
                              top: 5,
                              bottom: 5),

                          width: widget.isFromCart ? null : 195,
                          child: ProductWidgetWeb(
                            product: productList[index],
                            fromPopularItem: true,
                            isFromCart: widget.isFromCart,
                            index: index,
                            isFromCartSheet: widget.isFromCartSheet,
                          ),
                        );
                      },
                    ),
                  ),
                  ResponsiveHelper.isMobile(context)&& isShowArrow?  Positioned(
                      top: 90,
                      right: -5,
                      child: InkWell(
                        onTap: ()async{
                          scrollToRight();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4)
                            ),
                            child: Icon(Icons.arrow_forward_ios_sharp)),
                      )):SizedBox(),
                  ResponsiveHelper.isMobile(context)&& !isShowArrow?  Positioned(
                      top: 90,
                      left: -5,
                      child: InkWell(
                        onTap: (){
                          scrollToLeft();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4)
                            ),
                            child: Icon(Icons.arrow_back_ios)),
                      )):SizedBox()
                ],
              ),
            ),
            // ResponsiveHelper.isMobile(context)? SizedBox(): category.categoryList != null ? Column(
            //    children: [
            //      InkWell(
            //        onTap: (){
            //          showDialog(context: context, builder: (con) => Dialog(
            //            child: Container(height: 550, width: 600, child: CategoryPopUp())
            //          ));
            //        },
            //        child: Padding(
            //          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            //          child: CircleAvatar(
            //            radius: 35,
            //            backgroundColor: Theme.of(context).primaryColor,
            //            child: Text(getTranslated('view_all', context), style: TextStyle(fontSize: 14,color: Colors.white)),
            //          ),
            //        ),
            //      ),
            //      SizedBox(height: 10,)
            //    ],
            //  ): CategoryAllShimmer()
          ],
        )




      :
            widget.isBuffet?SizedBox(
              height:  220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: widget.isFromCart
                    ? productList.length
                    : productList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left:  10,
                        right: 5,
                        top: 5,
                        bottom: 5),
                    width: 195,
                    child: ProductWidgetWeb(
                      product: productList[index],
                      fromPopularItem: true,
                      isFromCart: widget.isFromCart,
                      index: index,
                      isFromCartSheet: widget.isFromCartSheet,
                    ),
                  );
                },
              ),
            ):
        GridView.builder(
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing:
            ResponsiveHelper.isMobile(context) ? 8 : 5,
            mainAxisSpacing: 5,
            childAspectRatio:
            ResponsiveHelper.isMobile(context) ?widget.isFromPointsScreen?1.8: 2.1 : 4,
            crossAxisCount:
            ResponsiveHelper.isTab(context) ? 2 : 2,
          ),
          itemCount: productList.length,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return  ProductWidget(
              product: productList[index],
              isFromPoinst: widget.isFromPointsScreen,
            );
          },
        )
            : Column(children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              ResponsiveHelper.isMobile(context) ? 8 : 5,
                          mainAxisSpacing: 5,
                          childAspectRatio:
                              ResponsiveHelper.isMobile(context) ? 2.1 : 4,
                          crossAxisCount:
                              ResponsiveHelper.isTab(context) ? 2 : 2,
                        ),
                  itemCount: productList.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return  ProductWidget(
                            product: productList[index],
                          );
                  },
                ),
                SizedBox(height: 30),
                productList != null
                    ? Padding(
                        padding:  const EdgeInsets.all(0),
                        child: prodProvider.isLoading
                                ? Center(
                                    child: Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    )),
                                  ))
                                : SizedBox.shrink(),
                      )
                    : SizedBox.shrink(),
              ]);
      },
    );
  }
}

class ProducCatView extends StatefulWidget {
  final ProductType productType;
  final ScrollController scrollController;
  bool isFromCart;
  bool isFromCartSheet;

  ProducCatView(
      {@required this.productType,
      this.scrollController,
      this.isFromCart = false,
      this.isFromCartSheet = false});

  @override
  State<ProducCatView> createState() => _ProducCatViewState();
}

class _ProducCatViewState extends State<ProducCatView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (!ResponsiveHelper.isDesktop(context) &&
        widget.productType == ProductType.LATEST_PRODUCT) {
      widget.scrollController?.addListener(() {
        if (widget.scrollController.position.pixels ==
                widget.scrollController.position.maxScrollExtent &&
            (_productProvider.latestProductList != null) &&
            !_productProvider.isLoading) {
          int pageSize;
          if (widget.productType == ProductType.LATEST_PRODUCT) {
            pageSize = (_productProvider.latestPageSize / 10).ceil();
          }
          if (_productProvider.latestOffset < pageSize) {
            _productProvider.latestOffset++;
            _productProvider.showBottomLoader();
            if (widget.productType == ProductType.LATEST_PRODUCT) {
              _productProvider.getLatestProductList(
                context,
                false,
                _productProvider.latestOffset.toString(),
                Provider.of<LocalizationProvider>(context, listen: false)
                    .locale
                    .languageCode,
              );
            }
          }
        }
      });
    }
    return Consumer<AllCategoryProvider>(
      builder: (context, prodProvider, child) {
        List<CategoryProductModel> productList;

        productList = prodProvider.categoryList;

        if (productList==null) {
          return SizedBox();
        }

        return ListView.builder(
            itemCount: productList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, ind) {
              return Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 6),
                  child: TitleWidget(title: productList[ind].name),
                ),

                GridView.builder(
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              ResponsiveHelper.isMobile(context) ? 8 : 5,
                          mainAxisSpacing: 5,
                          childAspectRatio:
                              ResponsiveHelper.isMobile(context) ? 2.1 : 4,
                          crossAxisCount:
                              ResponsiveHelper.isTab(context) ? 2 : 2,
                        ),
                  itemCount: productList[ind].products.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return  ProductWidget(
                            product: productList[ind].products[index],
                          );
                  },
                ),
                // SizedBox(height: 30),

                productList != null
                    ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: prodProvider.isLoading
                                ? Center(
                                    child: Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    )),
                                  ))
                                : SizedBox.shrink(),
                      )
                    : SizedBox.shrink(),
              ]);
            });
      },
    );
  }
}



///old code
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/category_product_model.dart';
// import 'package:flutter_restaurant/data/model/response/product_model.dart';
// import 'package:flutter_restaurant/helper/product_type.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/localization/language_constrants.dart';
// import 'package:flutter_restaurant/provider/category_provider.dart';
// import 'package:flutter_restaurant/provider/localization_provider.dart';
// import 'package:flutter_restaurant/provider/product_provider.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:flutter_restaurant/view/base/product_shimmer.dart';
// import 'package:flutter_restaurant/view/base/product_widget.dart';
// import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
// import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../provider/auth_provider.dart';
// import '../../../../provider/profile_provider.dart';
// import '../../../base/title_widget.dart';
//
// class ProductView extends StatefulWidget {
//   final ProductType productType;
//   final ScrollController scrollController;
//   bool isFromCart;
//   bool isFromCartSheet;
//   bool isBuffet;
//   bool isFromPointsScreen;
//
//
//   ProductView(
//       {@required this.productType,
//         this.scrollController,
//         this.isFromCart = false,
//         this.isBuffet=false,
//         this.isFromPointsScreen=false,
//         this.isFromCartSheet = false});
//
//   @override
//   State<ProductView> createState() => _ProductViewState();
// }
//
// class _ProductViewState extends State<ProductView> {
//   bool _isLoggedIn;
//
//
//
//   ScrollController scrollController=ScrollController();
//   bool isShowArrow=true;
//   final double _width = 50.0; // single item length
//   final listLength = 20;
//   final int baseScrollPoint = 3; // every click will move this much
//   double scrollWidth = 0.0;
//   int move = 1;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.isFromPointsScreen){
//       _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
//       if(_isLoggedIn) {
//         Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//       }
//     }
//     scrollController.addListener(() {
//       if (scrollController.position.atEdge) {
//         bool isTop = scrollController.position.pixels == 0;
//         if (isTop) {
//           print('At the top');
//           isShowArrow=true;
//           setState(() {
//
//           });
//         } else {
//           setState(() {
//             isShowArrow=false;
//
//           });
//           print('At the bottom:$isShowArrow');
//         }
//       }
//     });
//
//   }
//   scrollToRight(){
//     if(scrollWidth <= scrollController.offset){
//       setState(() {
//         scrollWidth = _width * baseScrollPoint * move;
//         move++;
//       });
//       scrollController.animateTo(scrollWidth, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
//     }
//   }
//
//   scrollToLeft(){
//     if(scrollWidth > 0){
//       setState(() {
//         move--;
//         scrollWidth = scrollWidth - (baseScrollPoint* _width);
//       });
//       scrollController.animateTo(scrollWidth, duration: Duration(milliseconds:300), curve: Curves.fastOutSlowIn);
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final _productProvider =
//     Provider.of<ProductProvider>(context, listen: false);
//
//     if (!ResponsiveHelper.isDesktop(context) &&
//         widget.productType == ProductType.LATEST_PRODUCT) {
//       widget.scrollController?.addListener(() {
//         if (widget.scrollController.position.pixels ==
//             widget.scrollController.position.maxScrollExtent &&
//             (_productProvider.latestProductList != null) &&
//             !_productProvider.isLoading) {
//           int pageSize;
//           if (widget.productType == ProductType.LATEST_PRODUCT) {
//             pageSize = (_productProvider.latestPageSize / 10).ceil();
//           }
//           if (_productProvider.latestOffset < pageSize) {
//             _productProvider.latestOffset++;
//             _productProvider.showBottomLoader();
//             if (widget.productType == ProductType.LATEST_PRODUCT) {
//               _productProvider.getLatestProductList(
//                 context,
//                 false,
//                 _productProvider.latestOffset.toString(),
//                 Provider.of<LocalizationProvider>(context, listen: false)
//                     .locale
//                     .languageCode,
//               );
//             }
//           }
//         }
//       });
//     }
//     return Consumer<ProductProvider>(
//       builder: (context, prodProvider, child) {
//         List<Product> productList;
//         if (widget.productType == ProductType.LATEST_PRODUCT) {
//           // productList = prodProvider.latestProductList;
//           productList = prodProvider.latestProductList;
//         } else if (widget.productType == ProductType.POPULAR_PRODUCT) {
//           productList = prodProvider.popularProductList;
//         } else if (widget.productType == ProductType.RELATED_PRODUCT) {
//           productList = prodProvider.relatedProducts;
//         }
//         else if (widget.productType == ProductType.LOYALTY_PRODUCT) {
//           productList = prodProvider.loyaltyPointsProducts;
//         }
//         else if (widget.productType == ProductType.RECOMMENDED_SIDES) {
//           productList = prodProvider.recommendedSidesList;
//         }
//         else if (widget.productType == ProductType.RECOMMENDED_BEVERAGES) {
//           productList = prodProvider.recommendedBeveragesList.reversed.toList();
//         }
//         if (productList == null) {
//           return widget.productType == ProductType.POPULAR_PRODUCT ||
//               widget.productType == ProductType.RELATED_PRODUCT|| widget.productType == ProductType.LOYALTY_PRODUCT||
//               widget.productType == ProductType.RECOMMENDED_SIDES|| widget.productType == ProductType.RECOMMENDED_BEVERAGES
//               ?widget.isFromCart? SizedBox(
//             height: widget.isFromCart ? 200 : 250,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               physics: BouncingScrollPhysics(),
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return Container(
//                   padding:
//                   EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                   width: widget.isFromCart ? 120 : 195,
//                   child: ProductWidgetWebShimmer(
//                     isFromCart: widget.isFromCart,
//                   ),
//                 );
//               },
//             ),
//           )
//               : GridView.builder(
//             shrinkWrap: true,
//             gridDelegate: ResponsiveHelper.isDesktop(context)
//                 ? SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 195, mainAxisExtent: 250)
//                 : SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisSpacing:
//               ResponsiveHelper.isMobile(context) ? 8 : 5,
//               mainAxisSpacing: 5,
//               childAspectRatio:
//               ResponsiveHelper.isMobile(context) ?widget.isFromPointsScreen?1.8: 2.1 : 4,
//               crossAxisCount:
//               ResponsiveHelper.isTab(context) ? 2 : 2,
//             ),
//             itemCount: 12,
//             itemBuilder: (BuildContext context, int index) {
//               return ResponsiveHelper.isDesktop(context)
//                   ? ProductWidgetWebShimmer(
//                 isFromCart: widget.isFromCart,
//               )
//                   : ProductShimmer(isEnabled: productList == null);
//             },
//             padding: EdgeInsets.symmetric(
//                 horizontal: Dimensions.PADDING_SIZE_SMALL),
//           ):SizedBox();
//         }
//         if (productList == null) {
//           return SizedBox();
//         }
//
//         return widget.productType == ProductType.POPULAR_PRODUCT ||
//             widget.productType == ProductType.RELATED_PRODUCT||
//             widget.productType == ProductType.LOYALTY_PRODUCT||
//             widget.productType == ProductType.RECOMMENDED_SIDES|| widget.productType == ProductType.RECOMMENDED_BEVERAGES
//
//             ?widget.isFromCart?            Row(
//           children: [
//             Expanded(
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   SizedBox(
//                     height: widget.isFromCart ? 200 : 220,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       physics: BouncingScrollPhysics(),
//                       controller: scrollController,
//                       itemCount: widget.isFromCart
//                           ? productList.length
//                           : productList.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: EdgeInsets.only(
//                               left: widget.isFromCart && index == 0 ? 0 : 10,
//                               right: 5,
//                               top: 5,
//                               bottom: 5),
//                           width: widget.isFromCart ? null : 195,
//                           child: ProductWidgetWeb(
//                             product: productList[index],
//                             fromPopularItem: true,
//                             isFromCart: widget.isFromCart,
//                             index: index,
//                             isFromCartSheet: widget.isFromCartSheet,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   ResponsiveHelper.isMobile(context)&& isShowArrow?  Positioned(
//                       top: 90,
//                       right: -5,
//                       child: InkWell(
//                         onTap: ()async{
//                           scrollToRight();
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.4)
//                             ),
//                             child: Icon(Icons.arrow_forward_ios_sharp)),
//                       )):SizedBox(),
//                   ResponsiveHelper.isMobile(context)&& !isShowArrow?  Positioned(
//                       top: 90,
//                       left: -5,
//                       child: InkWell(
//                         onTap: (){
//                           scrollToLeft();
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.4)
//                             ),
//                             child: Icon(Icons.arrow_back_ios)),
//                       )):SizedBox()
//                 ],
//               ),
//             ),
//             // ResponsiveHelper.isMobile(context)? SizedBox(): category.categoryList != null ? Column(
//             //    children: [
//             //      InkWell(
//             //        onTap: (){
//             //          showDialog(context: context, builder: (con) => Dialog(
//             //            child: Container(height: 550, width: 600, child: CategoryPopUp())
//             //          ));
//             //        },
//             //        child: Padding(
//             //          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
//             //          child: CircleAvatar(
//             //            radius: 35,
//             //            backgroundColor: Theme.of(context).primaryColor,
//             //            child: Text(getTranslated('view_all', context), style: TextStyle(fontSize: 14,color: Colors.white)),
//             //          ),
//             //        ),
//             //      ),
//             //      SizedBox(height: 10,)
//             //    ],
//             //  ): CategoryAllShimmer()
//           ],
//         )
//
//
//
//
//             :
//         widget.isBuffet?SizedBox(
//           height:  220,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: BouncingScrollPhysics(),
//             itemCount: widget.isFromCart
//                 ? productList.length
//                 : productList.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 padding: EdgeInsets.only(
//                     left:  10,
//                     right: 5,
//                     top: 5,
//                     bottom: 5),
//                 width: 195,
//                 child: ProductWidgetWeb(
//                   product: productList[index],
//                   fromPopularItem: true,
//                   isFromCart: widget.isFromCart,
//                   index: index,
//                   isFromCartSheet: widget.isFromCartSheet,
//                 ),
//               );
//             },
//           ),
//         ):
//         GridView.builder(
//           gridDelegate: ResponsiveHelper.isDesktop(context)
//               ? SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 195, mainAxisExtent: 250)
//               : SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisSpacing:
//             ResponsiveHelper.isMobile(context) ? 8 : 5,
//             mainAxisSpacing: 5,
//             childAspectRatio:
//             ResponsiveHelper.isMobile(context) ?widget.isFromPointsScreen?1.8: 2.1 : 4,
//             crossAxisCount:
//             ResponsiveHelper.isTab(context) ? 2 : 2,
//           ),
//           itemCount: productList.length,
//           padding: EdgeInsets.symmetric(
//               horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return ResponsiveHelper.isDesktop(context)
//                 ? Padding(
//               padding: const EdgeInsets.all(5.0),
//               child:
//               ProductWidgetWeb(product: productList[index],isFromLoyaltyPoints: widget.isFromPointsScreen,),
//             )
//                 : ProductWidget(
//               product: productList[index],
//               isFromPoinst: widget.isFromPointsScreen,
//             );
//           },
//         )
//             : Column(children: [
//           GridView.builder(
//             gridDelegate: ResponsiveHelper.isDesktop(context)
//                 ? SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 195, mainAxisExtent: 250)
//                 : SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisSpacing:
//               ResponsiveHelper.isMobile(context) ? 8 : 5,
//               mainAxisSpacing: 5,
//               childAspectRatio:
//               ResponsiveHelper.isMobile(context) ? 2.1 : 4,
//               crossAxisCount:
//               ResponsiveHelper.isTab(context) ? 2 : 2,
//             ),
//             itemCount: productList.length,
//             padding: EdgeInsets.symmetric(
//                 horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (BuildContext context, int index) {
//               return ResponsiveHelper.isDesktop(context)
//                   ? Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child:
//                 ProductWidgetWeb(product: productList[index]),
//               )
//                   : ProductWidget(
//                 product: productList[index],
//               );
//             },
//           ),
//           SizedBox(height: 30),
//           productList != null
//               ? Padding(
//             padding: ResponsiveHelper.isDesktop(context)
//                 ? const EdgeInsets.only(top: 40, bottom: 70)
//                 : const EdgeInsets.all(0),
//             child: ResponsiveHelper.isDesktop(context)
//                 ? prodProvider.isLoading
//                 ? Center(
//               child: Padding(
//                 padding: EdgeInsets.all(
//                     Dimensions.PADDING_SIZE_SMALL),
//                 child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<
//                         Color>(
//                         Theme.of(context).primaryColor)),
//               ),
//             )
//                 : (_productProvider.latestOffset ==
//                 (Provider.of<ProductProvider>(context,
//                     listen: false)
//                     .latestPageSize /
//                     10)
//                     .ceil())
//                 ? SizedBox()
//                 : SizedBox(
//               width: 500,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary:
//                   Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(30)),
//                 ),
//                 onPressed: () {
//                   _productProvider
//                       .moreProduct(context);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10),
//                   child: Text(
//                       getTranslated(
//                           'see_more', context),
//                       style: poppinsRegular.copyWith(
//                           fontSize: Dimensions
//                               .FONT_SIZE_OVER_LARGE)),
//                 ),
//               ),
//             )
//                 : prodProvider.isLoading
//                 ? Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(
//                       Dimensions.PADDING_SIZE_SMALL),
//                   child: CircularProgressIndicator(
//                       valueColor:
//                       AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor,
//                       )),
//                 ))
//                 : SizedBox.shrink(),
//           )
//               : SizedBox.shrink(),
//         ]);
//       },
//     );
//   }
// }
//
// class ProducCatView extends StatefulWidget {
//   final ProductType productType;
//   final ScrollController scrollController;
//   bool isFromCart;
//   bool isFromCartSheet;
//
//   ProducCatView(
//       {@required this.productType,
//         this.scrollController,
//         this.isFromCart = false,
//         this.isFromCartSheet = false});
//
//   @override
//   State<ProducCatView> createState() => _ProducCatViewState();
// }
//
// class _ProducCatViewState extends State<ProducCatView> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _productProvider =
//     Provider.of<ProductProvider>(context, listen: false);
//
//     if (!ResponsiveHelper.isDesktop(context) &&
//         widget.productType == ProductType.LATEST_PRODUCT) {
//       widget.scrollController?.addListener(() {
//         if (widget.scrollController.position.pixels ==
//             widget.scrollController.position.maxScrollExtent &&
//             (_productProvider.latestProductList != null) &&
//             !_productProvider.isLoading) {
//           int pageSize;
//           if (widget.productType == ProductType.LATEST_PRODUCT) {
//             pageSize = (_productProvider.latestPageSize / 10).ceil();
//           }
//           if (_productProvider.latestOffset < pageSize) {
//             _productProvider.latestOffset++;
//             _productProvider.showBottomLoader();
//             if (widget.productType == ProductType.LATEST_PRODUCT) {
//               _productProvider.getLatestProductList(
//                 context,
//                 false,
//                 _productProvider.latestOffset.toString(),
//                 Provider.of<LocalizationProvider>(context, listen: false)
//                     .locale
//                     .languageCode,
//               );
//             }
//           }
//         }
//       });
//     }
//     return Consumer<AllCategoryProvider>(
//       builder: (context, prodProvider, child) {
//         List<CategoryProductModel> productList;
//
//         productList = prodProvider.categoryList;
//
//         if (productList==null) {
//           return SizedBox();
//         }
//
//         return ListView.builder(
//             itemCount: productList.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.zero,
//             itemBuilder: (context, ind) {
//               return Column(children: [
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(10, 2, 10, 6),
//                   child: TitleWidget(title: productList[ind].name),
//                 ),
//
//                 GridView.builder(
//                   gridDelegate: ResponsiveHelper.isDesktop(context)
//                       ? SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 195, mainAxisExtent: 250)
//                       : SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisSpacing:
//                     ResponsiveHelper.isMobile(context) ? 8 : 5,
//                     mainAxisSpacing: 5,
//                     childAspectRatio:
//                     ResponsiveHelper.isMobile(context) ? 2.1 : 4,
//                     crossAxisCount:
//                     ResponsiveHelper.isTab(context) ? 2 : 2,
//                   ),
//                   itemCount: productList[ind].products.length,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ResponsiveHelper.isDesktop(context)
//                         ? Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: ProductWidgetWeb(
//                           product: productList[ind].products[index]),
//                     )
//                         : ProductWidget(
//                       product: productList[ind].products[index],
//                     );
//                   },
//                 ),
//                 // SizedBox(height: 30),
//
//                 productList != null
//                     ? Padding(
//                   padding: ResponsiveHelper.isDesktop(context)
//                       ? const EdgeInsets.only(top: 40, bottom: 70)
//                       : const EdgeInsets.all(0),
//                   child: ResponsiveHelper.isDesktop(context)
//                       ? prodProvider.isLoading
//                       ? Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(
//                           Dimensions.PADDING_SIZE_SMALL),
//                       child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<
//                               Color>(
//                               Theme.of(context).primaryColor)),
//                     ),
//                   )
//                       : (_productProvider.latestOffset ==
//                       (Provider.of<ProductProvider>(context,
//                           listen: false)
//                           .latestPageSize /
//                           10)
//                           .ceil())
//                       ? SizedBox()
//                       : SizedBox(
//                     width: 500,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary:
//                         Theme.of(context).primaryColor,
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(30)),
//                       ),
//                       onPressed: () {
//                         _productProvider
//                             .moreProduct(context);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10),
//                         child: Text(
//                             getTranslated(
//                                 'see_more', context),
//                             style: poppinsRegular.copyWith(
//                                 fontSize: Dimensions
//                                     .FONT_SIZE_OVER_LARGE)),
//                       ),
//                     ),
//                   )
//                       : prodProvider.isLoading
//                       ? Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(
//                             Dimensions.PADDING_SIZE_SMALL),
//                         child: CircularProgressIndicator(
//                             valueColor:
//                             AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).primaryColor,
//                             )),
//                       ))
//                       : SizedBox.shrink(),
//                 )
//                     : SizedBox.shrink(),
//               ]);
//             });
//       },
//     );
//   }
// }
