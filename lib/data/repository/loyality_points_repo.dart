import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class LoyalityPointsRepo {
  final HttpClient httpClient;

  LoyalityPointsRepo({@required this.httpClient});

  Future<ApiResponse> getPointsProductList() async {
    debugPrint('----getPointsProductList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.LOYALTY_POINTS_PRODUCTS}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getPointsProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
