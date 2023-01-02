// import 'dart:convert';
//
//
// AllProductsModel allProductsModelFromJson(String str) =>
//     AllProductsModel.fromJson(json.decode(str));
//
// class AllProductsModel {
//   AllProductsModel({
//     required this.data,
//     required this.links,
//     required this.meta,
//   });
//
//   List<ProductsModel> data;
//   Links links;
//   Meta meta;
//
//   factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
//       AllProductsModel(
//         data: json["data"] == null
//             ? <ProductsModel>[]
//             : List<ProductsModel>.from(
//             json["data"].map((x) => ProductsModel.fromJson(x))),
//         links: json["links"] == null
//             ? Links.fromJson({})
//             : Links.fromJson(json["links"]),
//         meta: json["meta"] == null
//             ? Meta.fromJson({})
//             : Meta.fromJson(json["meta"]),
//       );
// }
//
// class ProductsModel {
//   ProductsModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.star,
//     required this.info,
//     required this.description,
//     required this.category,
//     required this.favorite,
//     required this.price,
//     required this.discount,
//     required this.discountPrice,
//     required this.count,
//   });
//
//   int id;
//   String name;
//   String image;
//   int star;
//   String info;
//   String description;
//   String category;
//   int favorite;
//   int price;
//   String discount;
//   int discountPrice;
//   int count;
//
//   factory ProductsModel.fromJson(Map<String, dynamic> json) =>
//       ProductsModel(
//         id: json["id"] ?? 0,
//         name: json["name"] ?? "",
//         image: json["image"] ?? "",
//         star: json["star"] ?? "",
//         info: json["info"] ?? "",
//         description: json["description"] ?? "",
//         category: json["category"] ?? "",
//         favorite: json["favorite"] ?? 0,
//         price: json["price"] ?? 0,
//         discount: json["discount"] ?? "",
//         discountPrice: json["discountPrice"] ?? 0,
//         count: json["count"] ?? 0,
//       );
// }
//
// class Links {
//   Links({
//     required this.first,
//     required this.last,
//     required this.prev,
//     required this.next,
//   });
//
//   String first;
//   String last;
//   String prev;
//   String next;
//
//   factory Links.fromJson(Map<String, dynamic> json) => Links(
//     first: json["first"] ?? "",
//     last: json["last"] ?? "",
//     prev: json["prev"] ?? "",
//     next: json["next"] ?? "",
//   );
// }
//
// class Meta {
//   Meta({
//     required this.currentPage,
//     required this.from,
//     required this.lastPage,
//     required this.path,
//     required this.perPage,
//     required this.to,
//     required this.total,
//   });
//
//   int currentPage;
//   int from;
//   int lastPage;
//   String path;
//   int perPage;
//   int to;
//   int total;
//
//   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
//     currentPage: json["current_page"] ?? 0,
//     from: json["from"] ?? 0,
//     lastPage: json["last_page"] ?? 0,
//     path: json["path"] ?? "",
//     perPage: json["per_page"] ?? 0,
//     to: json["to"] ?? 0,
//     total: json["total"] ?? 0,
//   );
// }
//
// class Link {
//   Link({
//     required this.url,
//     required this.label,
//     required this.active,
//   });
//
//   String url;
//   String label;
//   bool active;
//
//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//     url: json["url"] ?? "",
//     label: json["label"] ?? "",
//     active: json["active"] ?? false,
//   );
// }
