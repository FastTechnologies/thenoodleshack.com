import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/repository/splash_repo.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

import '../data/model/response/policy_model.dart';
import '../helper/api_checker.dart';
import '../utill/app_toast.dart';
class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;

  SplashProvider({@required this.splashRepo});

  ConfigModel _configModel;
  BaseUrls _baseUrls;
  DateTime _currentTime = DateTime.now();
  PolicyModel _policyModel;


  ConfigModel get configModel => _configModel;
  BaseUrls get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;
  PolicyModel get policyModel => _policyModel;

  Future<bool> initConfig(BuildContext context) async {
    debugPrint('--config iniit');
    ApiResponse apiResponse = await splashRepo.getConfig();
  //  appToast(text: 'here is response :${apiResponse.response.body}');
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(jsonDecode(apiResponse.response.body));
      _baseUrls = ConfigModel.fromJson(jsonDecode(apiResponse.response.body)).baseUrls;


      debugPrint('====confige Model Response uri:${_baseUrls.restaurantImageUrl}/${_configModel.restaurantLogo}');
      debugPrint('====confige Model Response:${_configModel.termsAndConditions}');

      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      String _error;
      if(apiResponse.error is String) {
        _error = apiResponse.error;
      }else {
        _error = apiResponse.error.errors[0].message;
      }
      print(_error);
      showCustomSnackBar(_error, context);
    }
    return isSuccess;
  }

  Future<bool> initSharedData() {
    debugPrint('------initSharedData-----');
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  bool isRestaurantClosed(bool today) {
    DateTime _date = DateTime.now();
    if(!today) {
      _date = _date.add(Duration(days: 1));
    }
    int _weekday = _date.weekday;
    if(_weekday == 7) {
      _weekday = 0;
    }
    for(int index = 0; index <  _configModel.restaurantScheduleTime.length; index++) {
      if(_weekday.toString() ==  _configModel.restaurantScheduleTime[index].day) {
        return false;
      }
    }
    return true;
  }

  bool isRestaurantOpenNow(BuildContext context) {
    if(isRestaurantClosed(true)) {
      return false;
    }
    int _weekday = DateTime.now().weekday;
    if(_weekday == 7) {
      _weekday = 0;
    }
    for(int index = 0; index <  _configModel.restaurantScheduleTime.length; index++) {
      if(_weekday.toString() ==  _configModel.restaurantScheduleTime[index].day && DateConverter.isAvailable(
            _configModel.restaurantScheduleTime[index].openingTime,
            _configModel.restaurantScheduleTime[index].closingTime,
            context,
          )) {
        return true;
      }
    }
    return false;
  }

  Future<bool> getPolicyPage(BuildContext context) async {

    ApiResponse apiResponse = await splashRepo.getPolicyPage();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      debugPrint('1--------${jsonDecode(apiResponse.response.body)}');
      _policyModel = PolicyModel.fromJson(jsonDecode(apiResponse.response.body));
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      String _error;
      if(apiResponse.error is String) {
        _error = apiResponse.error;
      }else {
        _error = apiResponse.error.errors[0].message;
      }
      print(_error);
      ApiChecker.checkApi(context, apiResponse);
    }
    return isSuccess;
  }

}