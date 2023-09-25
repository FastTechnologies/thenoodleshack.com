import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/category_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

import '../data/model/response/category_product_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  List<Product> _categoryProductList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;
  String _selectedSubCategoryId;

  List<CategoryModel> get categoryList => _categoryList;

  List<CategoryModel> get subCategoryList => _subCategoryList;

  List<Product> get categoryProductList => _categoryProductList;

  bool get pageFirstIndex => _pageFirstIndex;

  bool get pageLastIndex => _pageLastIndex;

  bool get isLoading => _isLoading;

  String get selectedSubCategoryId => _selectedSubCategoryId;

  Future<void> getCategoryList(
      BuildContext context, bool reload, String languageCode) async {
    _subCategoryList = null;
    if (_categoryList == null || reload) {
      _isLoading = true;
      ApiResponse apiResponse =
          await categoryRepo.getCategoryList(languageCode);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _categoryList = [];
        jsonDecode(apiResponse.response.body).forEach(
            (category) => _categoryList.add(CategoryModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void getSubCategoryList(
      BuildContext context, String categoryID, String languageCode) async {
    _subCategoryList = null;
    _isLoading = true;
    ApiResponse apiResponse =
        await categoryRepo.getSubCategoryList(categoryID, languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _subCategoryList = [];
      jsonDecode(apiResponse.response.body).forEach(
          (category) => _subCategoryList.add(CategoryModel.fromJson(category)));
      getCategoryProductList(context, categoryID, languageCode);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void getCategoryProductList(
      BuildContext context, String categoryID, String languageCode,
      {String type = 'all'}) async {
    _categoryProductList = null;
    _selectedSubCategoryId = categoryID;
    notifyListeners();
    ApiResponse apiResponse = await categoryRepo.getCategoryProductList(
        categoryID, languageCode, type);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _categoryProductList = [];
      jsonDecode(apiResponse.response.body).forEach(
          (category) => _categoryProductList.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }

  int _selectCategory = -1;

  int get selectCategory => _selectCategory;

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }

  updateProductCurrentIndex(int index, int totalLength) {
    if (index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    } else {
      _pageFirstIndex = true;
      notifyListeners();
    }
    if (index + 1 == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    } else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }
}

class AllCategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;
  double catHeight = 110.0;
  bool _lister = true;
  double proHeight = 55.0;
  List<TabCat> tabs = [];
  TabController tabController;
  ScrollController scrollController = ScrollController();

  AllCategoryProvider({@required this.categoryRepo});

  List<CategoryProductModel> categoryList;

  List<ProductItem> categoryProductList = [];
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;
  String _selectedSubCategoryId;

  // List<CategoryProductModel> get categoryList => _categoryList;

  bool get pageFirstIndex => _pageFirstIndex;

  bool get pageLastIndex => _pageLastIndex;

  bool get isLoading => _isLoading;

  String get selectedSubCategoryId => _selectedSubCategoryId;

  Future<void> getCategoryList(
      BuildContext context, bool reload, String languageCode) async {
    if (categoryList == null || reload) {
      _isLoading = true;
      ApiResponse apiResponse =
          await categoryRepo.getAllCategoryProductList(languageCode);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        debugPrint('====new response:${apiResponse.response.body}');
        categoryList = [];
        jsonDecode(apiResponse.response.body).forEach((category) {
          debugPrint(
              '====new response:${CategoryProductModel.fromJson(category).name}:${CategoryProductModel.fromJson(category).products.length}');

          if (CategoryProductModel.fromJson(category).products.isNotEmpty) {
            categoryList.add(CategoryProductModel.fromJson(category));
          }
        });

        print('==new list:${categoryList}');
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void init(TickerProvider tickerProvider) {
    print('==tabs init ');
    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < categoryList.length; i++) {
      final category = categoryList[i];
      if (offsetFrom > 0) {
        offsetFrom += categoryList[i - 1].products.length * proHeight;
      }

      if (i < categoryList.length - 1) {
        offsetTo = offsetFrom + categoryList[i + 1].products.length * proHeight;
      } else {
        offsetTo = double.infinity;
      }
      tabs.add(
        TabCat(
            categoryProductModel: category,
            selected: (i == 0),
            offset: catHeight * i + offsetFrom,
            offsetTo: offsetTo),
      );
      for (int j = 0; j < category.products.length; j++) {
        final product = category.products[j];

        categoryProductList
            .add(ProductItem(product: product, categoryProductModel: category));
      }
    }

    tabController = TabController(length: tabs.length, vsync: tickerProvider);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_lister) {
      for (int i = 0; i < tabs.length; i++) {
        final _tab = tabs[i];
        if (scrollController.offset >= _tab.offset &&
            scrollController.offset <= _tab.offsetTo &&
            !_tab.selected) {
          onCategorySelected(i, animationRequired: false);
          tabController.animateTo(i);
          break;
        }
      }
    }
  }

  void onCategorySelected(int index, {animationRequired = true}) async {
    print('==selected index:${index}');
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected.categoryProductModel.name ==
          tabs[i].categoryProductModel.name;
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();
    if (animationRequired) {
      _lister = false;
      await scrollController.animateTo(selected.offset,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      _lister = true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}

class TabCat {
  CategoryProductModel categoryProductModel;
  bool selected;
  double offset;
  double offsetTo;

  TabCat(
      {this.categoryProductModel, this.selected, this.offset, this.offsetTo});

  TabCat copyWith(bool selected) => TabCat(
      categoryProductModel: categoryProductModel,
      selected: selected,
      offset: offset,
      offsetTo: offsetTo);
}

class ProductItem {
  CategoryProductModel categoryProductModel;
  Product product;

  ProductItem({this.categoryProductModel, this.product});

  bool get isCategory => categoryProductModel != null;
}
