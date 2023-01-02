import 'dart:convert';

CategoryInfoModel categoryModelFromJson(String str) =>
    CategoryInfoModel.fromJson(json.decode(str));

class CategoryInfoModel {
  CategoryInfoModel({
    required this.data,
  });

  List<CategoryData> data;

  factory CategoryInfoModel.fromJson(Map<String, dynamic> json) => CategoryInfoModel(
        data: json["data"] == null
            ? <CategoryData>[]
            : List<CategoryData>.from(
                json["data"].map((x) => CategoryData.fromJson(x))),
      );
}

class CategoryData {
  CategoryData({
    required this.categoryName,
    required this.image,
    required this.id,
  });

  String categoryName;
  String image;
  int id;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        categoryName: json["name"], image: json["image"], id: json["id"],
      );
}
