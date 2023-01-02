import 'package:image_picker/image_picker.dart';
import 'package:market/model/database_model/add_cart_database_model.dart';

import '../model/http_result.dart';
import 'api_provider.dart';

class Repository {
  final _apiProvider = ApiProvider();

  Future<HttpResult> addProduct(XFile image, String url, var data) =>
      _apiProvider.addProduct(image, url, data);

  Future<HttpResult> addCategory(XFile image, String url, var data) =>
      _apiProvider.addCategory(image, url, data);

  Future<HttpResult> sold(var map) => _apiProvider.sold(map);

  Future<HttpResult> acceptedProducts(int id, String acceptedTime) =>
      _apiProvider.acceptedProducts(id, acceptedTime);

  Future<HttpResult> favorite(int id) => _apiProvider.favorite(id);

  Future<HttpResult> addProductString(var data) =>
      _apiProvider.addProductString(data);

  Future<HttpResult> addCategoryString(var data) =>
      _apiProvider.addCategoryString(data);

  Future<HttpResult> addNewsString(var data) =>
      _apiProvider.addNewsString(data);

  Future<HttpResult> deleteProduct(int id) => _apiProvider.deleteProduct(id);

  Future<HttpResult> deleteCategory(int id) => _apiProvider.deleteCategory(id);

  Future<HttpResult> deleteBanner(int id) => _apiProvider.deleteBanner(id);
  Future<HttpResult> deleteHistoryDay() => _apiProvider.deleteHistoryDay();

  Future<HttpResult> deleteFavoriteList(int id) =>
      _apiProvider.deleteFavoriteList(id);

  Future<HttpResult> deleteHistorySoldList(int id) =>
      _apiProvider.deleteHistorySoldList(id);

  Future<HttpResult> addStar(int productId, int id) =>
      _apiProvider.addStar(productId, id);

  // Future<HttpResult> sendList(String email, String password) =>
  //     _apiProvider.sendList(email, password);

  Future<HttpResult> allProduct(int page) => _apiProvider.allProduct(page);

  Future<HttpResult> allBanners() => _apiProvider.allBanners();

  Future<HttpResult> allUsers(int page) => _apiProvider.allUsers(page);

  Future<HttpResult> allUsersSearch(int page, String search) =>
      _apiProvider.allUsersSearch(page, search);
 Future<HttpResult> allMaxMonthPrice(int page, String search) =>
      _apiProvider.allMaxMonthPrice(page, search);

  Future<HttpResult> userUpdate(int id, String name) =>
      _apiProvider.userUpdate(id, name);

  Future<HttpResult> getItemInfoProduct(int id) =>
      _apiProvider.getItemInfoProduct(id);

  Future<HttpResult> getProducts(int page) => _apiProvider.getProducts(page);

  Future<HttpResult> setDataNormalUser(int id,var data) => _apiProvider.setDataNormalUser(id,data);
  Future<HttpResult> getDayMonthPrice(var data) => _apiProvider.getDayMonthPrice(data);

  Future<HttpResult> getFavoriteInfo(int id) =>
      _apiProvider.getFavoriteInfo(id);

  Future<HttpResult> getHistoryInfo(int id, int page) =>
      _apiProvider.getHistoryInfo(id, page);

  Future<HttpResult> getHistories(int page) => _apiProvider.getHistories(page);

  Future<HttpResult> getNewsPaper() => _apiProvider.getNewsPaper();

  Future<HttpResult> getCategory() => _apiProvider.getCategory();

  Future<HttpResult> getUserInfo() => _apiProvider.getUserInfo();

  Future<HttpResult> getCategoryProducts(int page, String category) =>
      _apiProvider.getCategoryProducts(page, category);

  Future<HttpResult> getDiscountProducts(int page) =>
      _apiProvider.getDiscountProducts(page);

  Future<HttpResult> getSearchProducts(int page, String search) =>
      _apiProvider.getSearchProducts(page, search);

  /// register
  Future<HttpResult> register(
          String name, String phoneNumber, String password, String confirm) =>
      _apiProvider.register(name, phoneNumber, password, confirm);

  /// login
  Future<HttpResult> login(String phoneNumber, String password) =>
      _apiProvider.login(phoneNumber, password);

  /// log out
  Future<HttpResult> logOut() => _apiProvider.logOut();

  /// update password
  Future<HttpResult> updatePassword(String password, String newPassword) =>
      _apiProvider.updatePassword(password, newPassword);
}
