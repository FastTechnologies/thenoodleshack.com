import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class SetMenuRepo {
  final HttpClient httpClient;
  SetMenuRepo({@required this.httpClient});

  Future<ApiResponse> getSetMenuList(String languageCode) async {
    debugPrint('---getSetMenuList----');
    try {
      final response = await httpClient.get(AppConstants.SET_MENU_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );
      debugPrint('---getSetMenuList response"${response}--');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}