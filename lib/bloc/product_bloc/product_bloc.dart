//
// import 'dart:convert';
//
// import 'package:rxdart/rxdart.dart';
//
// import '../api/repository.dart';
// import '../model/http_result.dart';
// import '../model/product.dart';
//
// class ProductBloc {
//
//   final Repository _repository = Repository();
//   final _fetchProducts = PublishSubject<AllProductsModel>();
//
//   Stream<AllProductsModel> get getAllProducts => _fetchProducts.stream;
//
//
//   AllProductsModel productData = AllProductsModel.fromJson({});
//
//   allProducts(int page) async {
//     HttpResult response = await _repository.allProduct(page);
//     if (response.isSuccess) {
//       AllProductsModel data = allProductsModelFromJson(
//         json.encode(response.result),
//       );
//       if (page == 1) {
//         productData = AllProductsModel.fromJson({});
//       }
//       productData.data.addAll(data.data);
//       productData.links = data.links;
//       productData.meta = data.meta;
//       _fetchProducts.sink.add(productData);
//     }
//   }
// }
//
// final productBloc = ProductBloc();
