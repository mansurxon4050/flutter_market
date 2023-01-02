import 'dart:convert';

FavoriteModel favoriteModelFromJson(String str) =>
    FavoriteModel.fromJson(json.decode(str));

class FavoriteModel {
  FavoriteModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<FavoriteProductItemInfo> data;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      FavoriteModel(
        success: json["success"] ?? true,
        data: json["data"] == null
            ? <FavoriteProductItemInfo>[]
            : List<FavoriteProductItemInfo>.from(
            json["data"].map((x) => FavoriteProductItemInfo.fromJson(x))),
      );
}

class FavoriteProductItemInfo {
  FavoriteProductItemInfo({
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

  factory FavoriteProductItemInfo.fromJson(Map<String, dynamic> json) =>
      FavoriteProductItemInfo(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        star: json["star"],
        info: json["info"],
        description: json["description"],
        category: json["category"],
        price: json["price"],
        discount: json["discount"],
        discountPrice: json["discount_price"],
        count: json["count"],
        type:  json["type"],
      );
}
