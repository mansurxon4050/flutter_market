import 'dart:convert';

import '../home/home_model.dart';

AllUsersModel allUsersModelFromJson(String str) =>
    AllUsersModel.fromJson(json.decode(str));

class AllUsersModel {
  AllUsersModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  List<UserData> data;
  Links links;
  Meta meta;

  factory AllUsersModel.fromJson(Map<String, dynamic> json) => AllUsersModel(
        data: json["data"] == null
            ? <UserData>[]
            : List<UserData>.from(
                json["data"].map((x) => UserData.fromJson(x))),
        links: json["links"] == null
            ? Links.fromJson({})
            : Links.fromJson(json["links"]),
        meta: json["meta"] == null
            ? Meta.fromJson({})
            : Meta.fromJson(json["meta"]),
      );
}

class UserData {
  UserData({
    required this.id,
    required this.monthPrice,
    required this.name,
    required this.createdAt,
    required this.phoneNumber,
    required this.roleId,
  });

  int id;
  int monthPrice;
  String name;
  String createdAt;
  String phoneNumber;
  String roleId;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        createdAt: json["created_at"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        roleId: json["roleId"] ?? "",
        monthPrice: json["month_price"] ?? 0,
      );
}
