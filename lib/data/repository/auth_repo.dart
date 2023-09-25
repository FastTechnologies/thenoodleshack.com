import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/data/model/response/social_login_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../utill/app_toast.dart';
import '../../view/base/custom_snackbar.dart';

class AuthRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({@required this.httpClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel, context) async {
    try {
      var url = AppConstants.REGISTER_URI;
      debugPrint('---register url:${url}');
      http.Response response = await httpClient.post(
        url,
        data: signUpModel.toJson(),
      );
      debugPrint('---register body:${signUpModel.toJson()}');
      debugPrint('---register response:${response.body}');
      if (response.statusCode == 200) {
        return ApiResponse.withSuccess(response);
      } else {
        showCustomSnackBar(
            jsonDecode(response.body)['errors'][0]['message'].toString(),
            context);

        return ApiResponse.withError(ApiErrorHandler.getMessage(
            jsonDecode(response.body)['errors'][0]['message']));
      }
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String email, String password}) async {
    try {
      var url = AppConstants.LOGIN_URI;

      http.Response response = await httpClient.post(
        url,
        data: {
          "email_or_phone": email,
          "email": email,
          "password": password,
          "restaurant_id": AppConstants.restaurantId
        },
      );
      debugPrint('--login body:$email ,$password}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateToken() async {
    debugPrint('========updateToken called');
    try {
      String _deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          _deviceToken = await _saveDeviceToken();
        }
      } else {
        _deviceToken = await _saveDeviceToken();
      }

      if (!kIsWeb) {
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      }
      debugPrint('---app token  fb ${_deviceToken}');
      debugPrint('---app token  url ${AppConstants.TOKEN_URI}');

      http.Response response = await httpClient.post(
        AppConstants.TOKEN_URI,
        data: {
          "_method": "put",
          "cm_firebase_token": _deviceToken,
        },
      );

      debugPrint('---app token  response ${response.statusCode}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String> _saveDeviceToken() async {
    print('-------- _saveDeviceToken---------- ');

    String _deviceToken = '@';
    try {
      _deviceToken = await FirebaseMessaging.instance.getToken();
      print('--------Device Token---------- ' + _deviceToken);
    } catch (error) {
      print('error is: $error');
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- ' + _deviceToken);
    }
    print('--------Device Token---------- ' + _deviceToken);

    return _deviceToken;
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      //print({"email_or_phone": email});
      http.Response response =
          await httpClient.post(AppConstants.FORGET_PASSWORD_URI, data: {
        "email_or_phone": email,
        "email": email,
        "restaurant_id": AppConstants.restaurantId
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      print({"email_or_phone": email, "reset_token": token});
      debugPrint('url for order track :${AppConstants.VERIFY_EMAIL_URI}');

      http.Response response = await httpClient
          .post(AppConstants.VERIFY_TOKEN_URI, data: {
        "email_or_phone": email,
        "email": email,
        "reset_token": token
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String mail, String resetToken,
      String password, String confirmPassword) async {
    try {
      print({
        "_method": "put",
        "reset_token": resetToken,
        "password": password,
        "confirm_password": confirmPassword,
        "email_or_phone": mail
      });
      http.Response response = await httpClient.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword,
          "email_or_phone": mail,
          "email": mail
        },
      );
      debugPrint(
          'url reset Password :${AppConstants.BASE_URL + AppConstants.RESET_PASSWORD_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify email number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      http.Response response = await httpClient
          .post(AppConstants.CHECK_EMAIL_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      http.Response response = await httpClient.post(
          AppConstants.VERIFY_EMAIL_URI,
          data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //verify phone number

  Future<ApiResponse> checkPhone(String phone) async {
    try {
      http.Response response = await httpClient.post(
          AppConstants.CHECK_PHONE_URI,
          data: {"phone": phone, "restaurant_id": AppConstants.restaurantId});

      if (response.statusCode == 403) {
      //  appToast(text: jsonDecode(response.body)['errors'][0]['message']);
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      debugPrint('error ---phone here');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    try {
      var url = AppConstants.VERIFY_PHONE_URI;
      http.Response response = await httpClient.post(url, queryParameters: {
        "phone": phone.replaceAll(RegExp('[()\\-\\s]'), ''),
        "token": token
      }, data: {
        'phone': phone.replaceAll(RegExp('[()\\-\\s]'), ''),
        'token': token
      });

      debugPrint('----${response}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    httpClient.token = token;
    //httpClient.dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      print('----setting token');
      await sharedPreferences.setString(AppConstants.TOKEN, token);
      print('----done token');
    } catch (e) {
      print('----setting token error');

      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    }

    await httpClient.post(
      AppConstants.TOKEN_URI,
      data: {"_method": "put", "cm_firebase_token": '@'},
    );
    await sharedPreferences.remove(AppConstants.TOKEN);
    await sharedPreferences.remove(AppConstants.CART_LIST);
    await sharedPreferences.remove(AppConstants.USER_ADDRESS);
    await sharedPreferences.remove(AppConstants.SEARCH_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  Future<ApiResponse> deleteUser() async {
    try {
      http.Response response =
          await httpClient.delete(AppConstants.CUSTOMER_REMOVE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> socialLogin(SocialLoginModel socialLogin) async {
    print('------social login -- > ${socialLogin.toJson()}');
    print('------social gmail -- > ${socialLogin.email}');
    print('------social body -- > ${socialLogin}');

    try {
      http.Response response = await httpClient.post(
        AppConstants.SOCIAL_LOGIN,
        data: socialLogin.toJson(),
      );
      print('------social login response-- > ${response}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
