class Grocery {
  final int? id, productId, price, allPrice, count;
  final String? name, image, info, category, type;

  Grocery({
    this.id,
    this.productId,
    this.name,
    this.image,
    this.info,
    this.category,
    this.price,
    this.allPrice,
    this.count,
    this.type,
  });

  factory Grocery.fromMap(Map<String, dynamic> map) => Grocery(
        id: map['id'] ?? 0,
        productId: map['productId'],
        name: map['name'],
        image: map['image'],
        info: map['info'],
        category: map['category'],
        price: map['price'],
        allPrice: map['allPrice'],
        count: map['count'],
        type: map['type'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'info': info,
      'category': category,
      'price': price,
      'allPrice': allPrice,
      'count': count,
      'type': type,
    };
  }
}

/// Database product star and favorite checked
class ProductStarFavorInfoModel {
  final int? id, productId, star,favorite;

  ProductStarFavorInfoModel({
    this.id,
    this.productId,
    this.star,
    this.favorite,
  });

  factory ProductStarFavorInfoModel.fromMap(Map<String, dynamic> map) =>
      ProductStarFavorInfoModel(
        id: map['id'] ?? 0,
        productId: map['productId'],
        star: map['star'],
        favorite: map['favorite'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'star': star,
      'favorite': favorite
    };
  }
}
