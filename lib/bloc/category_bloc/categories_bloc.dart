import 'dart:convert';

import 'package:market/model/category/category_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/http_result.dart';

class CategoryBloc {
  final Repository repository = Repository();
  final _fetchCategories = PublishSubject<CategoryInfoModel>();

  Stream<CategoryInfoModel> get getCategoryStream => _fetchCategories.stream;

  CategoryInfoModel categoryModel = CategoryInfoModel.fromJson({});

  CategoryInfo() async {
    HttpResult response = await repository.getCategory();
    if (response.isSuccess) {
      CategoryInfoModel data = categoryModelFromJson(
        json.encode(response.result),
      );
      // if (page == 1) {
      //   itemProductData = ItemProductModel.fromJson({});
      // }
      categoryModel.data = [];
      categoryModel.data.addAll(data.data);
      _fetchCategories.sink.add(categoryModel);
    }
  }
}

final categoryBloc = CategoryBloc();
