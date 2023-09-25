import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class BannerRepo {
  final HttpClient httpClient;
  BannerRepo({@required this.httpClient});

  Future<ApiResponse> getBannerList() async {
    debugPrint('---getBannerList--');
    try {
      final response = await httpClient.get(AppConstants.BANNER_URI);
      debugPrint('---getBannerList--response:${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID, String languageCode) async {
    try {
      final response = await httpClient.get('${AppConstants.PRODUCT_DETAILS_URI}$productID&restaurant_id=${AppConstants.restaurantId}',
          options: Options(headers: {'X-localization': languageCode}));

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}