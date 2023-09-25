import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/model/response/PaymentCardModel.dart';

import '../data/model/response/base/api_response.dart';
import '../data/model/response/base/error_response.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/payment_repo.dart';
import '../helper/api_checker.dart';

class PaymentProvider with ChangeNotifier {
  PaymentRepo paymentRepo;

  PaymentProvider({@required this.paymentRepo});

  List<PyamentCardModel> _cardsList;
  PyamentCardModel _defaultCard;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  PyamentCardModel get defaultCard => _defaultCard;

  List<PyamentCardModel> get cardsList => _cardsList;

  getCardsList(BuildContext context) async {
    _isLoading = true;
    ApiResponse apiResponse = await paymentRepo.getAllCard();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _isLoading = false;
      _cardsList = [];

      jsonDecode(apiResponse.response.body).forEach(
          (address) => _cardsList.add(PyamentCardModel.fromJson(address)));
      if (_cardsList.isNotEmpty) {
        _defaultCard = _cardsList
            .where((element) => element.defaultCard == '1')
            .toList()[0];
      }else{
        _defaultCard=null;
      }
      print('==card list:${_cardsList.length}');
    } else {
      _isLoading = false;
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel> addCard(
      PyamentCardModel cardModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    // _addressStatusMessage = null;
    ApiResponse apiResponse = await paymentRepo.addCard(cardModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      debugPrint('======card success');

      //Map map = jsonDecode(apiResponse.response.body);
      //initAddressList(context);
      getCardsList(context);
      String message = 'Card added successfully';
      responseModel = ResponseModel(true, message);
      //_addressStatusMessage = message;
    } else {
      _isLoading = false;

      debugPrint('======card error');
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> setDefault(String id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    // _addressStatusMessage = null;
    ApiResponse apiResponse = await paymentRepo.setCardDefault(id);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      debugPrint('======card default success');

      //  Map map = jsonDecode(apiResponse.response.body);
      getCardsList(context);
      //initAddressList(context);
      //  String message = map["message"];
      String message = 'Payment Cards Set to Default Successfully';
      responseModel = ResponseModel(true, message);
      //_addressStatusMessage = message;
    } else {
      _isLoading = false;

      debugPrint('======card error');
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> removeCard(String id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    // _addressStatusMessage = null;
    ApiResponse apiResponse = await paymentRepo.removeCRD(id);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      debugPrint('======card default success');

      //  Map map = jsonDecode(apiResponse.response.body);
      getCardsList(context);
      //initAddressList(context);
      //  String message = map["message"];
      String message = 'Payment Cards Set to Default Successfully';
      responseModel = ResponseModel(true, message);
      //_addressStatusMessage = message;
    } else {
      _isLoading = false;

      debugPrint('======card error');
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }
}
