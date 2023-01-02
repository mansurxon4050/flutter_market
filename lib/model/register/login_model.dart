class LoginModel {
  LoginModel({
    required this.user,
    required this.token,
  });

  User user;
  String token;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        user: json["user"] == null
            ? User.fromJson({})
            : User.fromJson(json["user"]),
        token: json["token"] ?? "",
      );
}

class User {
  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.roleId,
  });

  int id;
  String name;
  String phoneNumber;
  String roleId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        roleId: json["roleId"] ?? "",
      );
}
