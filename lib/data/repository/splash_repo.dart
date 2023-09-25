import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utill/app_toast.dart';

class SplashRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.httpClient});

  Future<ApiResponse> getConfig() async {
   // appToast(text: 'here is response starting');

    try {
      print('---get config url ${AppConstants.CONFIG_URI}');
      var headers = {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      };
      // final response1 = await http.get(Uri.parse(AppConstants.BASE_URL+AppConstants.CONFIG_URI)  ,
      //   );
      // print('---get config resonse ${response1.body}');

      final response = await httpClient.get(AppConstants.CONFIG_URI,);
      // appToast(text: 'here is response :${response.body}');

      print('---get config resonse ${response.body}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      // appToast(text: 'here is response :${e}');
      //
      print('---get config error:  $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.ON_BOARDING_SKIP)) {
      return sharedPreferences.setBool(AppConstants.ON_BOARDING_SKIP, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  Future<ApiResponse> getPolicyPage() async {
    try {
      final response = await httpClient.get(AppConstants.POLICY_PAGE);
      debugPrint('2--------${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  int getBranchId() => sharedPreferences.getInt(AppConstants.BRANCH) ?? -1;

  Future<void> setBranchId(int id) async {
    await sharedPreferences.setInt(AppConstants.BRANCH, id);
    if(id != -1) {
      await httpClient.updateHeader(getToken: sharedPreferences.getString(AppConstants.TOKEN));
    }
  }
}