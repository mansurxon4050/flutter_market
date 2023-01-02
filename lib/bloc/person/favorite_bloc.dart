import 'dart:convert';

import 'package:market/model/person/favorite_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/http_result.dart';

class FavoriteProductBloc {
  final Repository repository = Repository();
  final _fetchProducts = PublishSubject<FavoriteModel>();

  Stream<FavoriteModel> get getFavoriteProducts => _fetchProducts.stream;


  FavoriteModel itemProductData = FavoriteModel.fromJson({});

  favoriteInfo(int userId) async {
    HttpResult response = await repository.getFavoriteInfo(userId);
    if (response.isSuccess) {
      FavoriteModel data = favoriteModelFromJson(
        json.encode(response.result),
      );
      itemProductData.data=[];
      itemProductData.data.addAll(data.data);
      _fetchProducts.sink.add(itemProductData);
    }
  }
}

final favoriteProductBloc = FavoriteProductBloc();
