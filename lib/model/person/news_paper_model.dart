import 'dart:convert';

NewsPaperModel newsPaperModelModelFromJson(String str) =>
    NewsPaperModel.fromJson(json.decode(str));

class NewsPaperModel {
  NewsPaperModel({
    required this.data,
  });

  List<NewsPaperDataModel> data;

  factory NewsPaperModel.fromJson(Map<String, dynamic> json) =>
      NewsPaperModel(
        data: json["data"] == null
            ? <NewsPaperDataModel>[]
            : List<NewsPaperDataModel>.from(
            json["data"].map((x) => NewsPaperDataModel.fromJson(x))),
      );
}

class NewsPaperDataModel {
  NewsPaperDataModel({
    required this.id,
    required this.name,
    required this.image,
    required this.info,
  });

  int id;
  String name;
  String image;
  String info;

  factory NewsPaperDataModel.fromJson(Map<String, dynamic> json) =>
      NewsPaperDataModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        info: json["info"],
      );
}
