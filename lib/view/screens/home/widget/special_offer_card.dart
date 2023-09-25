import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/offer_model.dart';
import 'package:flutter_restaurant/view/screens/home/widget/specialoffer_bottom_sheet.dart';

import '../../../../helper/responsive_helper.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/color_resources.dart';
import 'package:provider/provider.dart';

import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import 'cart_bottom_sheet.dart';

class SpecialOfferCard extends StatefulWidget {
  final SpecialOfferModel specialOfferModel;

  const SpecialOfferCard({Key key, this.specialOfferModel}) : super(key: key);

  @override
  State<SpecialOfferCard> createState() => _SpecialOfferCardState();
}

class _SpecialOfferCardState extends State<SpecialOfferCard> {
  @override
  Widget build(BuildContext context) {
    var imageUrl =
        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.offerUrl}/${widget.specialOfferModel.image}';
    print('--offer url:$imageUrl');

    return InkWell(
      onTap: () {
        _showOfferSheet(context, specialOfferModel: widget.specialOfferModel);
      },
      child: Container(
        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
              blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
              spreadRadius:
                  Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
            )
          ],
          color: ColorResources.COLOR_WHITE,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder_banner,
            height: 105,
            width: 195,
            fit: BoxFit.cover,
            image: imageUrl,
            imageErrorBuilder: (c, o, s) => Image.asset(
                Images.placeholder_banner,
                height: 105,
                width: 195,
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  void _showOfferSheet(BuildContext context,
      {SpecialOfferModel specialOfferModel}) {
    ResponsiveHelper.isMobile(context)
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => SpecialOffersBottomSheet(
              specialOfferModel: specialOfferModel,
            ),
          )
        : showDialog(
            context: context,
            builder: (con) => Dialog(
                  child: SpecialOffersBottomSheet(
                    specialOfferModel: specialOfferModel,
                  ),
                ));
  }
}
