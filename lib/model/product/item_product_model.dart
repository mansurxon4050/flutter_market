import 'dart:convert';

ItemProductModel itemProductModelFromJson(String str) =>
    ItemProductModel.fromJson(json.decode(str));

class ItemProductModel {
  ItemProductModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<ProductItemInfo> data;

  factory ItemProductModel.fromJson(Map<String, dynamic> json) =>
      ItemProductModel(
        success: json["success"] ?? true,
        data: json["data"] == null
            ? <ProductItemInfo>[]
            : List<ProductItemInfo>.from(
                json["data"].map((x) => ProductItemInfo.fromJson(x))),
      );
}

class ProductItemInfo {
  ProductItemInfo({
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

  factory ProductItemInfo.fromJson(Map<String, dynamic> json) =>
      ProductItemInfo(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        star: json["star"]??0,
        info: json["info"],
        description: json["description"],
        category: json["category"],
        price: json["price"],
        discount: json["discount"]??0,
        discountPrice: json["discount_price"]?? 0,
        count: json["count"],
        type:  json["type"],
      );
}
