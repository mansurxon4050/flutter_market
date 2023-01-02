import 'dart:convert';
import '../home/home_model.dart';


AllCategoryProductsModel allCategoryProductsModelFromJson(String str) =>
    AllCategoryProductsModel.fromJson(json.decode(str));

class AllCategoryProductsModel {
  AllCategoryProductsModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<CategoryProductsModel> data;
  Links links;
  Meta meta;

  factory AllCategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      AllCategoryProductsModel(
        data: json["data"] == null
            ? <CategoryProductsModel>[]
            : List<CategoryProductsModel>.from(
            json["data"].map((x) => CategoryProductsModel.fromJson(x))),
        links: json["links"] == null
            ? Links.fromJson({})
            : Links.fromJson(json["links"]),
        meta: json["meta"] == null
            ? Meta.fromJson({})
            : Meta.fromJson(json["meta"]),
      );
}

class CategoryProductsModel {
  CategoryProductsModel({
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

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      CategoryProductsModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        star: json["star"] ?? "",
        info: json["info"] ?? "",
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        price: json["price"] ?? 0,
        discount: json["discount"] ?? 0,
        discountPrice: json["discount_price"] ?? 0,
        count: json["count"] ?? 0,
        type:  json["type"] ?? 0,
      );
}
