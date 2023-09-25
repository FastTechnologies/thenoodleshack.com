import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/product_type.dart';
import '../../../helper/responsive_helper.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/loyality_points_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/not_logged_in_screen.dart';
import '../../base/web_app_bar.dart';
import '../home/widget/product_view.dart';

class HeartPointScreen extends StatefulWidget {
  const HeartPointScreen({Key key}) : super(key: key);

  @override
  State<HeartPointScreen> createState() => _HeartPointScreenState();
}

class _HeartPointScreenState extends State<HeartPointScreen> {
  bool _isLoggedIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getLoyaltyProductList(context);
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context,listen: false).getUserInfo(context);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
          child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(
          context: context,
          title: 'Reward Points',
          isBackButtonExist: false),

      body:Consumer<ProductProvider>(
        builder: (context, _cartProvider, child) {
          return       Padding(
          padding: EdgeInsets.all(
          Dimensions.PADDING_SIZE_SMALL),        child: SingleChildScrollView(
          child:_isLoggedIn? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Column(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Provider.of<ProfileProvider>(context,listen: false).userInfoModel!=null?   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${ Provider.of<ProfileProvider>(context,listen: false).userInfoModel.point??0.0}',style: rubikMedium.copyWith(fontSize: 50)),
                          SizedBox(width: 5,),
                          Icon(Icons.favorite,color: Theme.of(context).primaryColor,)
                        ],
                      ): Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          )),

                      Text('Hearts balance',style: rubikMedium.copyWith(fontSize: 20,fontWeight: FontWeight.w400)),

                    ],
                  ),
                ),
                SizedBox(height: 10,),

                Text('Rewards you can get with hearts',style: rubikMedium.copyWith(fontSize: 20)),
                SizedBox(height: 10,),
              ],
            ),






    ProductView(
    productType: ProductType.LOYALTY_PRODUCT,
    isFromPointsScreen: true,
    ),


    ],
    ): NotLoggedInScreen(),
    ),
    );



    }


    ));
  }
}
