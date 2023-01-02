
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/category/category_product_model.dart';
import '../../model/http_result.dart';

class CategoryProductsBloc {

  final Repository _repository = Repository();
  final _fetchCategoryProducts = PublishSubject<AllCategoryProductsModel>();

  Stream<AllCategoryProductsModel> get getAllStarProducts => _fetchCategoryProducts.stream;


  AllCategoryProductsModel allCategoryProductsData = AllCategoryProductsModel.fromJson({});

  allCategoryProductsMethod(int page,String category) async {
    HttpResult response = await _repository.getCategoryProducts(page,category);
    if (response.isSuccess) {
      AllCategoryProductsModel data = allCategoryProductsModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        allCategoryProductsData = AllCategoryProductsModel.fromJson({});
      }
      allCategoryProductsData.data.addAll(data.data);
      allCategoryProductsData.links = data.links;
      allCategoryProductsData.meta = data.meta;
      _fetchCategoryProducts.sink.add(allCategoryProductsData);
    }
  }
  allDiscountProductsMethod(int page,) async {
    HttpResult response = await _repository.getDiscountProducts(page);
    if (response.isSuccess) {
      AllCategoryProductsModel data = allCategoryProductsModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        allCategoryProductsData = AllCategoryProductsModel.fromJson({});
      }
      allCategoryProductsData.data.addAll(data.data);
      allCategoryProductsData.links = data.links;
      allCategoryProductsData.meta = data.meta;
      _fetchCategoryProducts.sink.add(allCategoryProductsData);
    }
  }
}

final categoryProductsBloc = CategoryProductsBloc();
