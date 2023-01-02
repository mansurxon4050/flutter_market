import 'dart:convert';
import '../home/home_model.dart';

AllSearchProductsModel allSearchProductsModelFromJson(String str) =>
    AllSearchProductsModel.fromJson(json.decode(str));

class AllSearchProductsModel {
  AllSearchProductsModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<SearchProductsModel> data;
  Links links;
  Meta meta;

  factory AllSearchProductsModel.fromJson(Map<String, dynamic> json) =>
      AllSearchProductsModel(
        data: json["data"] == null
            ? <SearchProductsModel>[]
            : List<SearchProductsModel>.from(
                json["data"].map((x) => SearchProductsModel.fromJson(x))),
        links: json["links"] == null
            ? Links.fromJson({})
            : Links.fromJson(json["links"]),
        meta: json["meta"] == null
            ? Meta.fromJson({})
            : Meta.fromJson(json["meta"]),
      );
}

class SearchProductsModel {
  SearchProductsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.star,
    required this.info,
    required this.description,
    required this.category,
    required this.price,
    required this.discount,
    required this.discountPrice,
    required this.count,
    required this.type,
  });

  int id;
  String name;
  String image;
  int star;
  String info;
  String description;
  String category;
  int price;
  int discount;
  int discountPrice;
  int count;
  String type;

  factory SearchProductsModel.fromJson(Map<String, dynamic> json) =>
      SearchProductsModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        star: json["star"] ?? "",
        info: json["info"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        price: json["price"] ?? 0,
        discount: json["discount"] ?? "",
        discountPrice: json["discountPrice"] ?? 0,
        count: json["count"] ?? 0,
        type: json["type"] ?? 0,
      );
}
