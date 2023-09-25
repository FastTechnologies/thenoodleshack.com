import 'dart:convert';

import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';

import '../data/model/response/deals_data_model.dart';
import '../data/model/response/offer_model.dart';
import 'localization_provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _popularProductList;
  List<Product> _loyaltyPointsProducts;
  List<Product> _recommendedSidesList;
  List<Product> _recommendedBeveragesList;
  List<SpecialOfferModel> _specialofferList;
  List<DealsDataModel> _dealList;
  List<int> checkedItems=[];
  List<String> checkedDrink=[];


  List<String> drinks=[
    'Coke',
    'Zero Coke',
    'Diet Coke',
    'Ginger Ale',
    'Orange',
    'Sprite',
  ];

  List<Product> _relatedProducts;
  List<Product> _latestProductList;
  bool _isLoading = false;
  int _popularPageSize;
  int _latestPageSize;
  List<String> _offsetList = [];
  List<int> _variationIndex = [0];
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<bool> _addFreqBoughtActive = [];
  List<int> _addOnQtyList = [];
  bool _seeMoreButtonVisible = true;
  int latestOffset = 1;
  int popularOffset = 1;
  int _cartIndex = -1;
  double tip = 0.0;
  bool _isReviewSubmitted = false;
  List<String> _productTypeList = ['all', 'non_veg', 'veg'];

  List<Product> get popularProductList => _popularProductList;

  List<Product> get relatedProducts => _relatedProducts;

  List<Product> get latestProductList => _latestProductList;
  List<Product> get recommendedSidesList => _recommendedSidesList;
  List<Product> get recommendedBeveragesList => _recommendedBeveragesList;

  List<Product> get loyaltyPointsProducts => _loyaltyPointsProducts;
  List<SpecialOfferModel> get specialofferList => _specialofferList;
  List<DealsDataModel> get dealsList => _dealList;

  bool get isLoading => _isLoading;

  int get popularPageSize => _popularPageSize;

  int get latestPageSize => _latestPageSize;

  List<int> get variationIndex => _variationIndex;

  int get quantity => _quantity;

  List<bool> get addOnActiveList => _addOnActiveList;

  List<bool> get addFreqBoughtActive => _addFreqBoughtActive;

  List<int> get addOnQtyList => _addOnQtyList;

  bool get seeMoreButtonVisible => _seeMoreButtonVisible;

  int get cartIndex => _cartIndex;

  bool get isReviewSubmitted => _isReviewSubmitted;

  List<String> get productTypeList => _productTypeList;

  Future<void> getLatestProductList(BuildContext context, bool reload,
      String _offset, String languageCode) async {
    if (reload || _offset == '1') {
      latestOffset = 1;
      _offsetList = [];
    }
    if (!_offsetList.contains(_offset)) {
      _offsetList = [];
      _offsetList.add(_offset);
      ApiResponse apiResponse =
          await productRepo.getLatestProductList(_offset, languageCode);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        print('${jsonDecode(apiResponse.response.body)}');
        if (reload || _offset == '1') {
          _latestProductList = [];
        }
        _latestProductList.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .products);
        _latestPageSize =
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> getPopularProductList(
      BuildContext context, bool reload, String _offset,
      {String type = 'all', bool isUpdate = false}) async {
    bool _apiSuccess = false;
    if (reload || _offset == '1') {
      popularOffset = 1;
      _offsetList = [];
      _popularProductList = null;
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(_offset)) {
      _offsetList = [];
      _offsetList.add(_offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(
        _offset,
        type,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode,
      );

      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _apiSuccess = true;
        if (reload || _offset == '1') {
          _popularProductList = [];
        }
        _popularProductList.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .products);
        _popularPageSize =
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return _apiSuccess;
  }

  Future<bool> getRelatedProductList(BuildContext context, id) async {
    bool _apiSuccess = false;
    _isLoading = true;

    ApiResponse apiResponse = await productRepo.getRelatedProductList(
      id,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _apiSuccess = true;

      _relatedProducts = [];
      jsonDecode(apiResponse.response.body).forEach(
          (product) => _relatedProducts.add(Product.fromJson(product)));

      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;

    return _apiSuccess;
  }
  Future<bool> getSpecialOffersList(BuildContext context) async {
    print('===getSpecialOffersList');
    bool _apiSuccess = false;
    _isLoading = true;

    ApiResponse apiResponse = await productRepo.getSpecialOffersList(

    );
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      print('===getSpecialOffersList: Response:${apiResponse.response.body}');

      _apiSuccess = true;

      _specialofferList = [];
      jsonDecode(apiResponse.response.body).forEach(
          (product) => _specialofferList.add(SpecialOfferModel.fromJson(product)));
      print('===getSpecialOffersList length:${_specialofferList.length}');

      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;

    return _apiSuccess;
  }
  Future<bool> getDealsList(BuildContext context) async {
    print('===getDealsList');
    bool _apiSuccess = false;
    _isLoading = true;

    ApiResponse apiResponse = await productRepo.getDealsList(

    );
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      print('===getDealsList: Response:${apiResponse.response.body}');

      _apiSuccess = true;

      _dealList = [];
      jsonDecode(apiResponse.response.body).forEach(
          (product) => _dealList.add(DealsDataModel.fromJson(product)));
      print('===getDealsList length:${_dealList.length}');

      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
    _isLoading = false;

    return _apiSuccess;
  }

  Future<void> getLoyaltyProductList(BuildContext context) async {
    if (5 == 5) {
      ApiResponse apiResponse = await productRepo.getPointsProductList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        print('${jsonDecode(apiResponse.response.body)}');
        _loyaltyPointsProducts = [];

        _loyaltyPointsProducts.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .products);

        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
  Future<void> getRecommendedSideList(BuildContext context) async {

      ApiResponse apiResponse = await productRepo.getRecommendedSideList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        print('${jsonDecode(apiResponse.response.body)}');
        _recommendedSidesList = [];

        _recommendedSidesList.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .products);

        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString(), context);
      }

      if (isLoading) {
        _isLoading = false;
        notifyListeners();

    }
  }
  Future<void> getRecommendedBeveragesList(BuildContext context) async {

      ApiResponse apiResponse = await productRepo.getRecommendedBeveragesList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        print('${jsonDecode(apiResponse.response.body)}');
        _recommendedBeveragesList = [];

        _recommendedBeveragesList.addAll(
            ProductModel.fromJson(jsonDecode(apiResponse.response.body))
                .products);

        _isLoading = false;
        notifyListeners();
      } else {
      //  showCustomSnackBar(apiResponse.error.toString(), context);
      }

      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }


  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void resetQuantity() {
    _quantity = 1;
    notifyListeners();
  }

  void initData(Product product, CartModel cart, BuildContext context) {
    _variationIndex = [];
    _addOnQtyList = [];
    checkedItems=[];
    _addOnActiveList = [];
    _addOnActiveList = [];
    if (cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if (cart.variation.length != null &&
          cart.variation.length > 0 &&
          cart.variation[0].type != null) {
        debugPrint('==choice1: ${cart.variation[0].type} ');

        _variationTypes.addAll(cart.variation[0].type.split('-'));
      }
      int _varIndex = 0;

      product.choiceOptions.forEach((choiceOption) {
        debugPrint('==choic e: ${choiceOption.options} ');
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') ==
              _variationTypes[_varIndex].trim()) {
            debugPrint('==choice2: ${index} ');

            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
      List<int> _addOnIdList = [];
      cart.addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if (_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList
              .add(cart.addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    } else {
      _quantity = 1;
      product.choiceOptions.forEach((element) => _variationIndex.add(0));
      product.addOns.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
      setExistInCart(product, context, notify: false);
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i, Product product,
      String variationType, BuildContext context) {
    _variationIndex[index] = i;
    _quantity = 1;
    setExistInCart(product, context);
    notifyListeners();
  }

  int setExistInCart(Product product, BuildContext context,
      {bool notify = true}) {
    List<String> _variationList = [];
    for (int index = 0; index < product.choiceOptions.length; index++) {
      _variationList.add(product
          .choiceOptions[index].options[_variationIndex[index]]
          .replaceAll(' ', ''));
    }
    String variationType = '';
    bool isFirst = true;
    _variationList.forEach((variation) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    });
    final _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cartIndex =
        _cartProvider.isExistInCart(product.id, variationType, false, null);
    if (_cartIndex != -1) {
      _quantity = _cartProvider.cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> _addOnIdList = [];
      _cartProvider.cartList[_cartIndex].addOnIds
          .forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if (_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(_cartProvider.cartList[_cartIndex]
              .addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }
    return _cartIndex;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    notifyListeners();
  }

  void addFrequently(bool isAdd, int index) {
    _addFreqBoughtActive[index] = isAdd;
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;

  List<String> get reviewList => _reviewList;

  List<bool> get loadingList => _loadingList;

  List<bool> get submitList => _submitList;

  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');

      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(
      ReviewBody reviewBody, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response =
        await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      responseModel = ResponseModel(
          true, getTranslated('review_submitted_successfully', context));
      updateSubmitted(true);

      notifyListeners();
    } else {
      _isLoading = false;

      notifyListeners();

      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateLoyaltyPoints(
      double points, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.updateLoyaltyPoints(points);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

      notifyListeners();
    } else {
      _isLoading = false;

      notifyListeners();

      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void moreProduct(BuildContext context) {
    int pageSize;
    pageSize = (latestPageSize / 10).ceil();

    if (latestOffset < pageSize) {
      latestOffset++;
      showBottomLoader();
      getLatestProductList(
        context,
        false,
        latestOffset.toString(),
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode,
      );
    }
  }

  void seeMoreReturn() {
    latestOffset = 1;
    _seeMoreButtonVisible = true;
  }

  updateSubmitted(bool value) {
    _isReviewSubmitted = value;
  }
}

class TipController extends GetxController {
  List tipsAmountList = ['1', '2', '3', 'Other'].obs;
  List tipPercentList = ['10', '15', '20', 'Other'].obs;
  List selectedTip = [].obs;
  final TextEditingController controller = TextEditingController();
  var tip = 0.0.obs;
  var isNotTip = false.obs;

  initialData(isFromCart, {double orderAmount}) {
    selectedTip.clear();
    tip.value=0.0;
    if (isFromCart) {
      selectedTip.add('15');

      double temp =
          (double.parse(selectedTip[0].toString()) / 100) * orderAmount;
      print('===init tip:${temp}');
      tip.value = temp;
    } else {
      selectedTip.add('2');
      tip.value = double.parse(selectedTip[0].toString());
    }
  }

  void updateTip(int index, isPercent, {double orderAmount}) {
    selectedTip.clear();
    if (isPercent) {
      selectedTip.add(tipPercentList[index]);

      if (index != 3) {
        double temp =
            (double.parse(selectedTip[0].toString()) / 100) * orderAmount;
        tip.value = temp;
      } else {
        tip.value = 0.0;
      }
    } else {
      selectedTip.add(tipsAmountList[index]);

      if (index != 3) {
        tip.value = double.parse(selectedTip[0].toString());
      } else {
        tip.value = 0.0;
      }
    }

    update();
  }
}
