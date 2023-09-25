
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class NewsLetterRepo {
  final HttpClient httpClient;

  NewsLetterRepo({@required this.httpClient});

  Future<ApiResponse> addToNewsLetter(String  email) async {
    try {
      final response = await httpClient.post(AppConstants.EMAIL_SUBSCRIBE_URI, data: {'email':email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
