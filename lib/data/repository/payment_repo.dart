import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

import '../model/response/PaymentCardModel.dart';

class PaymentRepo {
  final HttpClient httpClient;

  PaymentRepo({
    this.httpClient,
  });

  Future<ApiResponse> getAllCard() async {
    debugPrint('-----getAllCard Api');
    try {
      final response = await httpClient.post(AppConstants.GET_ALL_CARD);
      debugPrint('-----getAllCard Api response:${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeCRD(String id) async {
    debugPrint('-----removeAddressByID Api by id ${id} ');

    try {
      final response = await httpClient
          .post('${AppConstants.DELETE_CARD}', data: {"payment_id": id});

      debugPrint('-----removeAddressByID Api response:${response}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> setCardDefault(String id) async {
    debugPrint('-----setCardDefault Api by id ${id} ');

    try {
      final response = await httpClient.post('${AppConstants.SET_DEFAULT_CARD}',
          data: {"payment_id": id.toString()});

      debugPrint('-----setCardDefault Api response:${response}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addCard(PyamentCardModel cardModel) async {
    debugPrint('-----addCard ${cardModel.toJson()}');

    try {
      final response = await httpClient.post(
        AppConstants.ADD_CARD,
        data: cardModel.toJson(),
      );
      debugPrint('-----Add Card Api response:${response}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
