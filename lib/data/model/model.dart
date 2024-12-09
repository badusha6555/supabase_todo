import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final int age;
  final String image;
  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'image': image,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      image: json['image'] as String,
    );
  }
  static String encode(List<UserModel> users) => json.encode(
        users.map((user) => user.toJson()).toList(),
      );

  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
}
