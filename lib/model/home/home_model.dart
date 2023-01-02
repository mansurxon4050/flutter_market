import 'dart:convert';

AllStarProductModel allStarProductModelFromJson(String str) =>
    AllStarProductModel.fromJson(json.decode(str));

class AllStarProductModel {
  AllStarProductModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<StarProductModel> data;
  Links links;
  Meta meta;

  factory AllStarProductModel.fromJson(Map<String, dynamic> json) =>
      AllStarProductModel(
        data: json["data"] == null
            ? <StarProductModel>[]
            : List<StarProductModel>.from(
                json["data"].map((x) => StarProductModel.fromJson(x))),
        links: json["links"] == null
            ? Links.fromJson({})
            : Links.fromJson(json["links"]),
        meta: json["meta"] == null
            ? Meta.fromJson({})
            : Meta.fromJson(json["meta"]),
      );
}

class StarProductModel {
  StarProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.star,
    required this.info,
  });

  int id;
  String name;
  String image;
  int price;
  int star;
  String info;

  factory StarProductModel.fromJson(Map<String, dynamic> json) =>
      StarProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        star: json["star"],
        info: json["info"],
      );
}


class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  String first;
  String last;
  String prev;
  String next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"] ?? "",
        last: json["last"] ?? "",
        prev: json["prev"] ?? "",
        next: json["next"] ?? "",
      );
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"] ?? 0,
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 0,
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
      );
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? "",
        label: json["label"] ?? "",
        active: json["active"] ?? false,
      );
}
