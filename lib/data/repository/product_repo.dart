import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/branch_provider.dart';
import '../../utill/app_toast.dart';

class ProductRepo {
  final HttpClient httpClient;

  ProductRepo({@required this.httpClient});

  Future<ApiResponse> getLatestProductList(
      String offset, String languageCode) async {
    debugPrint('----getLatestProductList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.LATEST_PRODUCT_URI}?limit=12&&offset=$offset&&restaurant_id=${AppConstants.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      print(languageCode);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getLatestProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

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

  Future<ApiResponse> getSpecialOffersList() async {
    debugPrint('----getPointsProductList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.SPECIAL_OFFER_URL}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getPointsProductList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDealsList() async {
    debugPrint('----getDealsList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.DEALS_URL}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getDealsList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedSideList() async {
    debugPrint('----getRecommendedSideList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.RECOMMENDED_SIDES_URL}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getRecommendedSideList error :$e');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedBeveragesList() async {
    debugPrint('----getRecommendedSideList--');
    try {
      final response = await httpClient.get(
        '${AppConstants.RECOMMENDED_BARVAGES_URL}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('----getRecommendedSideList error :$e');
      // appToast(text: 'response:${e}');

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPopularProductList(
      String offset, String type, String languageCode) async {
    debugPrint('----getPopularProductList--');

    try {
      final response = await httpClient.get(
        '${AppConstants.ALL_POPULAR_PRODUCT_URI}&branch_id=${Provider.of<BranchProvider>(Get.context, listen: false).branch}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRelatedProductList(int id, String languageCode) async {
    debugPrint('----getRelatedProductList--');

    try {
      final response = await httpClient.get(
        '${AppConstants.RELATED_PRODUCTS}$id?restaurant_id=${AppConstants.restaurantId}',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // Future<ApiResponse> searchProduct(String productId, String languageCode) async {
  //   debugPrint('----searchProduct--');
  //
  //   try {
  //     final response = await httpClient.get(
  //       '${AppConstants.SEARCH_PRODUCT_URI}$productId',
  //       options: Options(headers: {'X-localization': languageCode}),
  //     );
  //     debugPrint('----searchProduct response: ${response}');
  //
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response =
      await httpClient.post(AppConstants.REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await httpClient
          .post(AppConstants.DELIVER_MAN_REVIEW_URI, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateLoyaltyPoints(double points) async {
    try {
      final response = await httpClient
          .post(AppConstants.USE_LOYALTY_URI, data: {'point': points});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
