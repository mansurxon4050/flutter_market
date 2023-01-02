import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/http_result.dart';
import '../../model/product/item_product_model.dart';

class ProductItemBloc {
  final Repository repository = Repository();
  final _fetchProducts = PublishSubject<ItemProductModel>();

  Stream<ItemProductModel> get getItemInfoProducts => _fetchProducts.stream;


  ItemProductModel itemProductData = ItemProductModel.fromJson({});

  productInfo(int id) async {
    HttpResult response = await repository.getItemInfoProduct(id);
    if (response.isSuccess) {
      ItemProductModel data = itemProductModelFromJson(
        json.encode(response.result),
      );
      // if (page == 1) {
      //   itemProductData = ItemProductModel.fromJson({});
      // }
      itemProductData.data=[];
      itemProductData.data.addAll(data.data);
      _fetchProducts.sink.add(itemProductData);
    }
  }
  allProductInfo(int page) async {
    HttpResult response = await repository.getProducts( page);
    if (response.isSuccess) {
      ItemProductModel data = itemProductModelFromJson(
        json.encode(response.result),
      );
      // itemProductData.data=[];
      itemProductData.data.addAll(data.data);
      _fetchProducts.sink.add(itemProductData);
    }
  }

}

  final productItemBloc = ProductItemBloc();
