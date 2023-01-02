import 'dart:convert';

import '../home/home_model.dart';

AllHistoryModel allHistoryModelFromJson(String str) =>
    AllHistoryModel.fromJson(json.decode(str));

class AllHistoryModel {
  AllHistoryModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<HistoryInfo> data;
  Links links;
  Meta meta;

  factory AllHistoryModel.fromJson(Map<String, dynamic> json) =>
      AllHistoryModel(
        data: json["data"] == null
            ? <HistoryInfo>[]
            : List<HistoryInfo>.from(
                json["data"].map((x) => HistoryInfo.fromJson(x))),
        links: json["links"] == null
            ? Links.fromJson({})
            : Links.fromJson(json["links"]),
        meta: json["meta"] == null
            ? Meta.fromJson({})
            : Meta.fromJson(json["meta"]),
      );
}

class HistoryInfo {
  HistoryInfo({
    required this.id,
    required this.userId,
    required this.paymentType,
    required this.totalPrice,
    required this.address,
    required this.muljal,
    required this.userName,
    required this.addressPhoneNumber,
    required this.long,
    required this.lat,
    required this.orderTime,
    required this.acceptedTime,
    required this.data,
    required this.createdAt,
    required this.delete,
    required this.make,
    required this.ready,
    required this.driver,
  });

  int id;
  int userId;
  String paymentType;
  int totalPrice;
  int delete;
  String address;
  String orderTime;
  String acceptedTime;
  String muljal;
  String userName;
  String addressPhoneNumber;
  String make;
  String ready;
  String driver;
  dynamic long;
  dynamic lat;
  List<HistoryInfoData> data;
  DateTime createdAt;

  factory HistoryInfo.fromJson(Map<String, dynamic> json) => HistoryInfo(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        paymentType: json["payment_type"] ?? '',
        totalPrice: json["total_price"] ?? 0,
        address: json["address"] ?? '',
        muljal: json["muljal"] ?? '',
        addressPhoneNumber: json["address_phone_number"] ?? '',
        long: json["long"],
        lat: json["lat"],
        acceptedTime: json["accepted_time"] ?? '',
        orderTime: json["order_time"] ?? '',
        data: json["data"] == null
            ? <HistoryInfoData>[]
            : List<HistoryInfoData>.from(
                json["data"].map((x) => HistoryInfoData.fromJson(x))),
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        userName: json["name"] ?? '',
        make: json["make"] ?? '',
        driver: json["driver"] ?? '',
        ready: json["ready"] ?? '',
        delete: json["delete"] ?? 0,
      );
}

class HistoryInfoData {
  HistoryInfoData({
    required this.id,
    required this.info,
    required this.name,
    required this.type,
    required this.count,
    required this.price,
    required this.allPrice,
    required this.category,
  });

  int id;
  String info;
  String name;
  String type;
  int count;
  dynamic price;
  dynamic allPrice;
  String category;

  factory HistoryInfoData.fromJson(Map<String, dynamic> json) =>
      HistoryInfoData(
        id: json["id"] ?? 0,
        info: json["info"] ?? 0,
        name: json["name"] ?? 0,
        type: json["type"] ?? 0,
        count: json["count"] ?? 0,
        price: json["price"] ?? 0,
        allPrice: json["allPrice"] ?? 0,
        category: json["category"] ?? 0,
      );
}
