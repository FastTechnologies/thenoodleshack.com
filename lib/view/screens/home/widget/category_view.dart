import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../new_home.dart';

class CategoryView extends StatefulWidget {
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
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

    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
          SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 80,
                        child: category.categoryList != null ? category.categoryList.length > 0 ? NotificationListener<ScrollEndNotification>(
                          onNotification: (scrollEnd) {
                            final metrics = scrollEnd.metrics;
                            if (metrics.atEdge) {
                              bool isTop = metrics.pixels == 0;
                              if (isTop) {
                                setState(() {
                                  isShowArrow=true;

                                });
                              } else {
                                setState(() {
                                  isShowArrow=false;

                                });
                              }
                            }
                            return true;
                          },
                          child: ListView.builder(
                            itemCount: category.categoryList.length,
                            padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                            physics: BouncingScrollPhysics(),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String _name = '';
                              category.categoryList[index].name.length > 15  ? _name = category.categoryList[index].name.substring(0, 15)+' ...' : _name = category.categoryList[index].name;
                              return Padding(
                                padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                child: InkWell(
                                  onTap: () {
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Categories',)));

                                    Navigator.pushNamed(
                                      context, Routes.getCategoryRoute(index),
                                    );
                                  },
                                  child: Column(children: [
                                    ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover,
                                        image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                            ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}':'',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover),
                                        // width: 100, height: 100, fit: BoxFit.cover,
                                      ),
                                    ),

                                    Flexible(
                                      child: Text(
                                        _name,
                                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                  ]),
                                ),
                              );
                            },
                          ),
                        ) : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),
                      ),
                      ResponsiveHelper.isMobile(context)&& isShowArrow?  Positioned(
                        top: 20,
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
                        top: 20,
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
            ),

          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65, width: 65, 
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65, width: 65,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

