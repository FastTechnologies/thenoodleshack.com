import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

import '../../../helper/responsive_helper.dart';
import '../../../provider/cart_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/routes.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/product_widget.dart';
import '../../base/web_app_bar.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.selectedIndex}) : super(key: key);

  final String title;
  final int selectedIndex;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          context: context,
          title: 'Food Menu',
          isBackButtonExist: true),
      body: Consumer<AllCategoryProvider>(
        builder: (context, category, child) {
          Provider.of<CartProvider>(context).setFalse();

// print('==is :${category.categoryList.length}');
// print('==is :${category.categoryList.where((element) => element.products.length!=0).toList()}');

       return category.isLoading?Center(
           child: CircularProgressIndicator(
             valueColor: new AlwaysStoppedAnimation<Color>(
                 Theme.of(context).primaryColor),
           )): ScrollableListTabView(
        tabHeight: 48,
        bodyAnimationDuration: const Duration(milliseconds: 150),
        tabAnimationCurve: Curves.easeOut,
        // seletedIndex:widget.selectedIndex ,
        tabAnimationDuration: const Duration(milliseconds: 200),
        tabs:List.generate(category.categoryList.length, (index) =>     ScrollableListTab(
            tab: ListTab(
                borderColor: Colors.transparent,
                activeBackgroundColor:  Theme.of(context).primaryColor,



                label: Text(category.categoryList[index].name),
                // icon: Icon(Icons.group),
                showIconOnList: false),
            body:
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing:
                ResponsiveHelper.isMobile(context) ? 8 : 5,
                mainAxisSpacing: 5,
                childAspectRatio:
                ResponsiveHelper.isMobile(context) ? 2.1 : 4.5,
                crossAxisCount:
                ResponsiveHelper.isTab(context) ? 2 : 2,
              ),
              itemCount:  category.categoryList[index].products.length,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int ind) {
                return ProductWidget(
                  product: category.categoryList[index].products[ind],
                );
              },
            ),

            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   itemCount: category.categoryList[index].products.length,
            //
            //   itemBuilder: (_, ind) => SizedBox(
            //       height: 100,
            //       child: ProductWidget(product:category.categoryList[index].products[ind])),
            // )


        )).toList()
        ,
       );
    }),
      bottomNavigationBar:Consumer<CartProvider>(
          builder: (context, cart, child) {
            return cart.isFromCategory==true?  Container(
                width: 1170,
                padding: EdgeInsets
                    .all(Dimensions
                    .PADDING_SIZE_SMALL),
            child: CustomButton(
            btnTxt: 'View in cart',
            onTap: () {
              Navigator.pushNamed(context, Routes.getDashboardRoute('cart'));
            }

      ),
    ):SizedBox.shrink();

    }
      )


    );
  }
}



/// old code

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title,this.selectedIndex}) : super(key: key);
//
//   final String title;
//   final int selectedIndex;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: ResponsiveHelper.isDesktop(context)
//             ? PreferredSize(
//             child: WebAppBar(), preferredSize: Size.fromHeight(100))
//             : CustomAppBar(
//             context: context,
//             title: 'Food Menu',
//             isBackButtonExist: true),
//         body: Consumer<AllCategoryProvider>(
//             builder: (context, category, child) {
// // print('==is :${category.categoryList.length}');
// // print('==is :${category.categoryList.where((element) => element.products.length!=0).toList()}');
//
//               return category.isLoading?Center(
//                   child: CircularProgressIndicator(
//                     valueColor: new AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor),
//                   )): ScrollableListTabView(
//                 tabHeight: 48,
//                 bodyAnimationDuration: const Duration(milliseconds: 150),
//                 tabAnimationCurve: Curves.easeOut,
//                 seletedIndex:widget.selectedIndex ,
//                 tabAnimationDuration: const Duration(milliseconds: 200),
//                 tabs:List.generate(category.categoryList.length, (index) =>     ScrollableListTab(
//                   tab: ListTab(
//                       borderColor: Colors.transparent,
//                       activeBackgroundColor:  Theme.of(context).primaryColor,
//
//
//
//                       label: Text(category.categoryList[index].name),
//                       // icon: Icon(Icons.group),
//                       showIconOnList: false),
//                   body:
//                   GridView.builder(
//                     gridDelegate: ResponsiveHelper.isDesktop(context)
//                         ? SliverGridDelegateWithMaxCrossAxisExtent(
//                         maxCrossAxisExtent: 195, mainAxisExtent: 250)
//                         : SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisSpacing:
//                       ResponsiveHelper.isMobile(context) ? 8 : 5,
//                       mainAxisSpacing: 5,
//                       childAspectRatio:
//                       ResponsiveHelper.isMobile(context) ? 2.1 : 4.5,
//                       crossAxisCount:
//                       ResponsiveHelper.isTab(context) ? 2 : 2,
//                     ),
//                     itemCount:  category.categoryList[index].products.length,
//                     padding: EdgeInsets.symmetric(
//                         horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int ind) {
//                       return ResponsiveHelper.isDesktop(context)
//                           ? Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: ProductWidgetWeb(
//                             product:  category.categoryList[index].products[ind]),
//                       )
//                           : ProductWidget(
//                         product: category.categoryList[index].products[ind],
//                       );
//                     },
//                   ),
//
//                   // ListView.builder(
//                   //   shrinkWrap: true,
//                   //   physics: NeverScrollableScrollPhysics(),
//                   //   padding: EdgeInsets.symmetric(horizontal: 10),
//                   //   itemCount: category.categoryList[index].products.length,
//                   //
//                   //   itemBuilder: (_, ind) => SizedBox(
//                   //       height: 100,
//                   //       child: ProductWidget(product:category.categoryList[index].products[ind])),
//                   // )
//
//
//                 )).toList()
//                 ,
//               );
//             })
//     );
//   }
// }


