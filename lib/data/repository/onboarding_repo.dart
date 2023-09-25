import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/onboarding_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:http/http.dart' as http;

class OnBoardingRepo {
  final HttpClient httpClient;

  OnBoardingRepo({@required this.httpClient});

  getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onboarding_one, 'Priority Home Delivery or Takeaway', 'Order directly from our app to save money in fees, get faster service, earn free food via our rewards program, and support local business.'),
        OnBoardingModel(Images.onboarding_two, 'Enjoy Free Appetizer after signup', 'Join our exclusive hearts reward program, win \$500! Be entered in a drawing to win on the 1st of next month.'),
        // OnBoardingModel(Images.onboarding_three, getTranslated('delivery_to_your_home', context), getTranslated('get_food_delivery_at_home', context)),
      ];

      //http.Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return onBoardingList;
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
