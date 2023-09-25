
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/screens/address/widget/deleteConfirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/response/PaymentCardModel.dart';

class CardWidget extends StatelessWidget {
  final PyamentCardModel paymentModel;
  final int index;
  CardWidget({@required this.paymentModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: () {
          if(paymentModel != null) {
         //   Navigator.pushNamed(context, Routes.getMapRoute(paymentModel));
          }
        },
        child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          height: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL), color: ColorResources.getSearchBg(context),
          border: Border.all(color:paymentModel.defaultCard=='1'? Theme.of(context).primaryColor:Colors.transparent)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Icon(
                       Icons.credit_card,
                      //color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.45),
                      size: 22,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            paymentModel.customerAccount,
                            style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.65)),
                          ),
                          Text(
                            "${paymentModel.cardNo}****${paymentModel.cardNo}",
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              InkWell(

                  onTap: (){
                    showDialog(context: context, barrierDismissible: false, builder: (context) => CardDeleteConfirmationDialog(paymentCardModel: paymentModel,index: index));

                  },
                  child: Icon(Icons.delete,color: Colors.red,))
            ],
          ),
        ),
      ),
    );
  }
}
