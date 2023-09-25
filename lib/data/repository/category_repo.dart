import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/branch_provider.dart';
import '../../utill/app_toast.dart';

class CategoryRepo {
  final HttpClient httpClient;

  CategoryRepo({@required this.httpClient});

  Future<ApiResponse> getCategoryList(String languageCode) async {
    try {
      final response = await httpClient.get(
        AppConstants.CATEGORY_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllCategoryProductList(String languageCode) async {
    try {
      //appToast(text: ' getAllCategoryProductList started');

      final response = await httpClient.get(
        '${AppConstants.ALL_PRODUCTS}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
        options: Options(headers: {'X-localization': languageCode}),
      );

      //  appToast(text: ' getAllCategoryProductList :${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList(
      String parentID, String languageCode) async {
    debugPrint('-----getSubCategoryList');
    try {
      final response = await httpClient.get(
        '${AppConstants.SUB_CATEGORY_URI}$parentID?restaurant_id=${AppConstants.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('-----getSubCategoryList response: ${response}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(
      String categoryID, String languageCode, String type) async {
    debugPrint(
        '-----getCategoryProductList url:${AppConstants.BASE_URL + AppConstants.CATEGORY_PRODUCT_URI}$categoryID?product_type=$type');

    try {
      final response = await httpClient.get(
        '${AppConstants.CATEGORY_PRODUCT_URI}$categoryID?product_type=$type&restaurant_id=${AppConstants.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('-----getCategoryProductList response: ${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
