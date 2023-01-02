// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_result.dart';

class ApiProvider {
  static Duration durationTimeout = const Duration(seconds: 30);
  static const String baseUrl = "http://mansurer.beget.tech/api/";

  ///register
  Future<HttpResult> register(String name, String phoneNumber,
      String password, String confirm) async {
    var data = {
      "name": name,
      "roleId": "user",
      "phone_number": phoneNumber,
      "password": password,
      "password_confirm": confirm,
    };
    return _postRequest(
      "${baseUrl}register",
      data,
    );
  }
  /// add photo and product
  Future<HttpResult> addProduct(XFile image, String url,var data) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          baseUrl + url,
        ),


      );
      request.fields['id']=data['id'].toString();
      request.fields['name']=data['name'];
      request.fields['info']=data['info'];
      request.fields['description']=data['description'];
      request.fields['category']=data['category'];
      request.fields['type']=data['type'];
      request.fields['star']=data['star'].toString();
      request.fields['price']=data['price'].toString();
      request.fields['discount']=data['discount'].toString();
      request.fields['discount_price']=data['discount_price'].toString();
      request.fields['count']=data['count'].toString();
      request.headers.addAll(await _header());
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
      var response = await request.send();
      http.Response responseData =
      await http.Response.fromStream(response).timeout(durationTimeout);

      return _result(responseData);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    }
  }
  /// add photo and category
  Future<HttpResult> addCategory(XFile image, String url,var data) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          baseUrl + url,
        ),


      );
      request.fields['id']=data['id'].toString();
      request.fields['name']=data['name'];
      request.fields['info']=data['info'];
      request.headers.addAll(await _header());
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
      var response = await request.send();
      http.Response responseData =
      await http.Response.fromStream(response).timeout(durationTimeout);

      return _result(responseData);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: "Internet error",
      );
    }
  }


  /// add sold history list
  Future<HttpResult> sold(var map) async {
    return _postRequest(
      "${baseUrl}history/sold",
      map,
    );
  }

  /// add sold history list
  Future<HttpResult> userUpdate(int id,String name) async {
    var data={
      "id":id,
      "roleId":name
    };
    return _postRequest(
      "${baseUrl}admin/users/update",
      data,
    );
  }

  /// add favorite product
  Future<HttpResult> favorite(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt("userId");
    var data = {"userId": userId, "productId": id};

    return _postRequest(
      "${baseUrl}product/favorite/add",
      data,
    );
  }

  /// update product string
  Future<HttpResult> addProductString(var data) async {
    return _postRequest(
      "${baseUrl}admin/product/update_str",
      data,
    );
  }
  /// update category string
  Future<HttpResult> addCategoryString(var data) async {
    return _postRequest(
      "${baseUrl}admin/category/update_str",
      data,
    );
  }
  /// update news string
  Future<HttpResult> addNewsString(var data) async {
    return _postRequest(
      "${baseUrl}admin/news/update_str",
      data,
    );
  }
/// product delete
  Future<HttpResult> deleteProduct(int id) async {
    return _delete("${baseUrl}admin/product/delete?id=$id");
  }
/// category delete
  Future<HttpResult> deleteCategory(int id) async {
    return _delete("${baseUrl}admin/category/delete?id=$id");
  }
/// delete Banner
  Future<HttpResult> deleteBanner(int id) async {
    return _delete("${baseUrl}admin/banner/delete?id=$id");
  }
/// delete history 30 day
  Future<HttpResult> deleteHistoryDay() async {
    return _delete("${baseUrl}admin/history/day/delete");
  }

  /// delete favorite list
  Future<HttpResult> deleteFavoriteList(int id) {
    return _delete("${baseUrl}product/favorite/delete?id=$id");
  }

  /// delete historySold list
  Future<HttpResult> deleteHistorySoldList(int id) {
    return _delete("${baseUrl}history/delete?id=$id");
  }

  /// addStar
  Future<HttpResult> addStar(int productId, int count) async {
    var data = {"id": productId, "star": count};

    return _postRequest(
      "${baseUrl}product/star/add",
      data,
    );
  }

  ///login
  Future<HttpResult> login(String phone_number, String password) async {
    var data = {
      "phone_number": phone_number,
      "password": password,
    };
    return _postRequest(
      "${baseUrl}login",
      data,
    );
  }

  ///  logOut
  Future<HttpResult> logOut() async {
    var data = {};
    return _postRequest(
      "${baseUrl}logout",
      data,
    );
  }

  /// update password
  Future<HttpResult> updatePassword(String password, String newPassword) async {
    var data = {
      "password": password,
      "newPassword": newPassword,
    };
    return _postRequest(
      "${baseUrl}update_password",
      data,
    );
  }

  // Future<HttpResult> sendList(String email, String password) async {
  //   var data = {
  //     "email": email,
  //     "password": password,
  //   };
  //   return _postRequest(
  //     "${baseUrl}login",
  //     data,
  //   );
  // }

  /// News paper
  Future<HttpResult> getNewsPaper() async {
    return _getRequest(
      baseUrl + ("news"),
    );
  }

  /// search products
  Future<HttpResult> getSearchProducts(int page, String search) async {
    return _getRequest(
      baseUrl + ("search/?search=$search&page=$page"),
    );
  }

  ///get category name
  Future<HttpResult> getCategory() async {
    return _getRequest(
      baseUrl + ("category"),
    );
  }

  /// get User Info
  Future<HttpResult> getUserInfo() async {
    return _getRequest(
      baseUrl + ("me"),
    );
  }

  ///get category Products
  Future<HttpResult> getCategoryProducts(int page, String category) async {
    return _getRequest(
      baseUrl + ("category/products/?category=$category&page=$page"),
    );
  }

  ///get history user_id
  Future<HttpResult> getHistoryInfo(int id, int page) async {
    return _getRequest(
      baseUrl + ("history/index?userId=$id&page=$page"),
    );
  }
  ///get history all
  Future<HttpResult> getHistories(int page) async {
    return _getRequest(
      baseUrl + ("history/all?page=$page"),
    );
  }

  /// buyurtmani qabul qildi
  Future<HttpResult> acceptedProducts(int id, String acceptedTime) async {
    return _getRequest(
      baseUrl + ("history/accepted?id=$id&accepted_time=$acceptedTime"),
    );
  }

  ///get discount Products
  Future<HttpResult> getDiscountProducts(int page) async {
    return _getRequest(
      baseUrl + ("discount/?page=$page"),
    );
  }

  ///get product item
  Future<HttpResult> getItemInfoProduct(int id) async {
    return _getRequest(
      baseUrl + ("product/item/?id=$id"),
    );
  }

  ///get product all
  Future<HttpResult> getProducts(int page) async {
    return _getRequest(
      baseUrl + ("admin/product/index?page=$page"),
    );
  }

  /// set data Normal user
  Future<HttpResult> setDataNormalUser(int id,var data) async {
    return _postRequest(
      baseUrl + ("admin/order/accept"),
      data
    );
  }

  /// get Day Month all Price
  Future<HttpResult> getDayMonthPrice(var data) async {
    return _postRequest(
      baseUrl + ("admin/history/cash"),
      data
    );
  }

  ///get product item
  Future<HttpResult> getFavoriteInfo(int id) async {
    return _getRequest(
      baseUrl + ("product/favorite/index?id=$id"),
    );
  }

  ///all product
  Future<HttpResult> allProduct(int page) async {
    return await _getRequest(
      baseUrl + ("product/popular/?page=$page"),
    );
  }

  ///all Banners
  Future<HttpResult> allBanners() async {
    return await _getRequest(
      baseUrl + ("banner/index"),
    );
  }

  ///all users admin
  Future<HttpResult> allUsers(int page) async {
    return await _getRequest(
      baseUrl + ("admin/users/index?page=$page"),
    );
  }

  ///all users search admin
  Future<HttpResult> allUsersSearch(int page,String search) async {
    return await _getRequest(
      baseUrl + ("admin/users/search?page=$page&search=$search"),
    );
  }
 ///all Max Month Price admin
  Future<HttpResult> allMaxMonthPrice(int page,String search) async {
    return await _getRequest(
      baseUrl + ("admin/users/month_price?page=$page&search=$search"),
    );
  }

  /// Post Request
  static Future<HttpResult> _postRequest(url, body) async {
    final Map<String, String> headers = await _header();
    if (kDebugMode) {
      print(url);
      print(headers);
      print(json.encode(body));
    }
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: json.encode(body),
          )
          .timeout(durationTimeout);

      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result:translate('internet_error'),
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate('internet_error'),
      );
    }
  }

  ///http GET Request
  static Future<HttpResult> _getRequest(url) async {
    final Map<String, String> headers = await _header();
    if (kDebugMode) {
      print(url);
      print(headers);
    }
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result:translate('internet_error'),
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate('internet_error'),
      );
    }
  }

  ///http Result
  static HttpResult _result(http.Response response) {
    if (kDebugMode) {
      print(response.statusCode);
      print('response.body');
      print(response.body);
    }
    int status = response.statusCode;
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return HttpResult(
        isSuccess: true,
        status: status,
        result: json.decode(utf8.decode(response.bodyBytes)),
      );
    } else if (response.statusCode == 401) {
      // RxBus.post("", tag: "CLOSED_USER");
      return HttpResult(
        isSuccess: false,
        status: status,
        result: translate('server_error')
      );
    } else if (response.statusCode == 500 || response.statusCode == 404) {
      return HttpResult(
        isSuccess: false,
        status: status,
        result: translate('server_error')
      );
    } else {
      try {
        var result = json.decode(utf8.decode(response.bodyBytes));
        return HttpResult(
          isSuccess: false,
          status: status,
          result: result,
        );
      } catch (_) {
        return HttpResult(
          isSuccess: false,
          status: status,
          result: translate('server_error')
        );
      }
    }
  }

  ///http DELETE Request
  static Future<HttpResult> _delete(url) async {
    final Map<String, String> headers = await _header();
    if (kDebugMode) {
      print(url);
      print(headers);
    }
    try {
      http.Response response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate('internet_error'),
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: translate('internet_error'),
      );
    }
  }

  ///Header
  static Future<Map<String, String>> _header() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    if (token == null) {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
      };
    } else {
      return {
        "Accept": "application/json",
        'content-type': 'application/json; charset=utf-8',
        "Authorization": "Bearer $token"
      };
    }
  }
}
