
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/model/home/home_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../api/repository.dart';
import '../../model/home/banner_model.dart';
import '../../model/http_result.dart';

class StarProductBloc {

  final Repository _repository = Repository();
  final _fetchProducts = PublishSubject<AllStarProductModel>();
  final _fetchBanners = PublishSubject<Banners>();

  Stream<AllStarProductModel> get getAllStarProducts => _fetchProducts.stream;
  Stream<Banners> get getAllBanners => _fetchBanners.stream;


  AllStarProductModel starProductData = AllStarProductModel.fromJson({});
  Banners bannersData = Banners.fromJson({});

  allStarProducts(int page) async {
    HttpResult response = await _repository.allProduct(page);
    if (response.isSuccess) {
      AllStarProductModel data = allStarProductModelFromJson(
        json.encode(response.result),
      );
      if (page == 1) {
        starProductData = AllStarProductModel.fromJson({});
      }
      starProductData.data.addAll(data.data);
      starProductData.links = data.links;
      starProductData.meta = data.meta;
      _fetchProducts.sink.add(starProductData);
    }
  }
  allBanners() async {
    HttpResult response = await _repository.allBanners();
    if (response.isSuccess) {
      Banners data = bannerFromJson(
        json.encode(response.result),
      );
      bannersData.data = [];
      bannersData.data.addAll(data.data);
      _fetchBanners.sink.add(bannersData);
    }
  }
}

final starProductBloc = StarProductBloc();
