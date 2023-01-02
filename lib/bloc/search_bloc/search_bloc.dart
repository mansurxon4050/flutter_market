import 'dart:convert';
import 'package:market/model/search/search_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../api/repository.dart';
import '../../model/http_result.dart';

class CategoryProductsBloc {

  final Repository _repository = Repository();
  final _fetchSearchProducts = PublishSubject<AllSearchProductsModel>();

  Stream<AllSearchProductsModel> get getAllSearchProductStream => _fetchSearchProducts.stream;

  AllSearchProductsModel allSearchProductsData = AllSearchProductsModel.fromJson({});

  allSearchProductsMethod(int page,String search) async {
    HttpResult response = await _repository.getSearchProducts(page,search);
    if (response.isSuccess) {
      AllSearchProductsModel data = allSearchProductsModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        allSearchProductsData = AllSearchProductsModel.fromJson({});
      }
      allSearchProductsData.data.addAll(data.data);
      allSearchProductsData.links = data.links;
      allSearchProductsData.meta = data.meta;
      _fetchSearchProducts.sink.add(allSearchProductsData);
    }
  }
}

final searchBloc = CategoryProductsBloc();
