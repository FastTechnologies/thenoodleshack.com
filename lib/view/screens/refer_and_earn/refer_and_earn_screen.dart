import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/refer_and_earn/widget/refer_hint_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helper/dynamic_link.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String> shareItem = ['messenger', 'whatsapp', 'gmail', 'viber', 'share' ];
  final List<String> hintList = [
    'Invite your friends & businesses',
    'They register ${AppConstants.APP_NAME} with special offer. Once They spend their first 25\$ Order both of you will get 5\$ coupon',
    'You made your earning !',
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    DynamicLinkHelp().inItDynamicLinkData(context);
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(context: context, title: 'Refer & Earn'),

      body: _isLoggedIn ? Center(child: ExpandableBottomSheet(
        background: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          child: Column(
            children: [
              SizedBox(
                width:  double.maxFinite,
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    return profileProvider.userInfoModel != null ? Column(
                      children: [
                        Image.asset(Images.refer_banner, height: _size.height * 0.3),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                        Text(
                         'Invite friend and businesses',
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                            color: Theme.of(context).textTheme.bodyLarge.color,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                        Text(
                          'Copy your code, share it with your friends',
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

                        Text(
                          'Your personal code',
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

                        DottedBorder(
                          padding: EdgeInsets.all(4),
                          borderType: BorderType.RRect,
                          radius: Radius.circular(20),
                          dashPattern: [5, 5],
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          strokeWidth: 2,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),

                                  child: Text('${profileProvider.userInfoModel.referCode ?? 'referal code'}',
                                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                  ),
                                ),

                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {

                                    if(profileProvider.userInfoModel.referCode != null && profileProvider.userInfoModel.referCode  != ''){
                                      Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.referCode : ''}'));
                                      showCustomSnackBar('Referral Code Copied', context, isError: false);
                                    }
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text('Copy',style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white.withOpacity(0.9),
                                    )),
                                  ),
                                ),

                              ]),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

                        Text(
                          'OR SHARE',
                          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: shareItem.map((_item) => InkWell(
                              borderRadius: BorderRadius.circular(10),
                           onTap: (){
                             DynamicLinkHelp().buildDynamicLinks(AppConstants.APP_NAME, '${profileProvider.userInfoModel.referCode}', 'Signup on ${AppConstants.APP_NAME} restaurant mobile app and get \$5.Use ${profileProvider.userInfoModel.fName} referral code to activate coupon at signup. Enjoy!\n \nReferral code: ${profileProvider.userInfoModel.referCode} ',);
                           },
                           //   onTap: () => Share.share('Download ${AppConstants.APP_NAME} restaurant mobile app and get \$5. Use my referral code: ${profileProvider.userInfoModel.referCode} to activate coupon at signup. Enjoy!'),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Image.asset(
                                  Images.getShareIcon(_item), height: 50, width: 50,
                                ),
                              ),
                            )).toList(),),
                        ),



                      ],
                    ) : SizedBox();
                  }
                ),
              ),

             //FooterView(),
            ],
          ),
        ),
        persistentContentHeight: MediaQuery.of(context).size.height * 0.2,
        expandableContent:  ReferHintView(hintList: hintList),
      )) : NotLoggedInScreen(),
    );
  }
}
