import 'package:data_table_try/data/enums.dart';

class User {
  final int? id;
  final String? name;
  final String? userName;
  final String? image;
  final String? password;
  final UserRole? role;

  User(
      {this.userName,
      this.id,
      this.name,
      this.image,
      this.password,
      this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        name: json["name"],
        userName: json["username"],
        image: json["image"],
        role: UserRole.getUserRole(json["role"]));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["username"] = userName;
    data["image"] = image;
    data["password"] = password;
    data["role"] = role!.toInt();
    return data;
  }
}
