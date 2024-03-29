import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

class RegisterModel {
  RegisterModel({
    required this.user,
    required this.token,
  });

  User user;
  String token;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        user: json["user"] == null
            ? User.fromJson({})
            : User.fromJson(json["user"]),
        token: json["api_token"] ?? "",
      );
}

class User {
  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.token,
  });

  String name;
  String email;
  String phoneNumber;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        updatedAt: json["updated_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]),
        id: json["id"] ?? 0,
        token: json["api_token"] ?? "",
      );
}
