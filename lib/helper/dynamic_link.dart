import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../utill/routes.dart';

class DynamicLinkHelp{
  FirebaseDynamicLinks dynamicLinks= FirebaseDynamicLinks.instance;

  void inItDynamicLinkData(context,)async{
    dynamicLinks.onLink.listen((dynamicLink) {
      if(dynamicLink!=null){
        handleUri(dynamicLink.link,context);
      }


    }).onError((error){
      print('onLink error');
      print(error.message);
    });
  }
  void handleUri(Uri uri,context)async{
    List<String> separatedLikn=[];
    separatedLikn.addAll(uri.path.split('/'));
    Navigator.pushNamed(context, Routes.getLoginRoute());
    //Navigator.pushNamed(context, Routes.getSignUpRoute(code));

  }
  buildDynamicLinks(String title,String code,String description,) async {
    print('=dynamicm staet');
    String url = "http://thenooideleshack.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$code'),
      androidParameters:const AndroidParameters(
        packageName: "com.thenooideleshack.fasttech",
        minimumVersion: 0,
      ),

      iosParameters:const IOSParameters(
        bundleId: "com.thenooideleshack.fasttech",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: 'Use This Coupon ${code}: ',
          //imageUrl: Uri.parse("$image"),
          title: title),
    );
    final ShortDynamicLink shortLink =
    await dynamicLinks.buildShortLink(parameters);

    String desc = '${shortLink.shortUrl.toString()}';
    print('=dynamicm shet');

    await Share.share('Link:${desc}\n${description}', subject: title,);

  }




}