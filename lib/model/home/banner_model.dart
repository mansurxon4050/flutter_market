import 'dart:convert';

Banners bannerFromJson(String str) => Banners.fromJson(json.decode(str));

class Banners {
  Banners({
    required this.data,
  });

  List<BannerData> data;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    data: json["data"] == null ? <BannerData>[] : List<BannerData>.from(json["data"].map((x) => BannerData.fromJson(x))),
  );
}

class BannerData {
  BannerData({
    required this.id,
    required this.image,
  });

  int id;
  String image;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    id: json["id"] ,
    image: json["image"],
  );
}
