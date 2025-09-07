import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String name;
  final String email;
  final String pass;

  static UserModel? lastUser;

  UserModel({required this.name, required this.email, required this.pass});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json["email"],
      pass: json['pass'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "pass": pass};
  }

  static Future<void> saveUser(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(user.email, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser({required String email}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final user = sharedPreferences.getString(email);
    if (user == null) {
      return null;
    } else {
      return UserModel.fromJson(jsonDecode(user));
    }
  }

  static Future<UserModel?> checkIfUserHere({
    required String email,
    required String pass,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final user = sharedPreferences.getString(email);
    if (user == null) {
      return null;
    }
    UserModel currUser = UserModel.fromJson(jsonDecode(user));
    if (currUser.pass == pass) {
      lastUser = UserModel.fromJson(jsonDecode(user));
      return lastUser;
    }
    return null;
  }

  static Future getAllUsers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // طبع العدد
    int count = sharedPreferences.getKeys().length;
    print("Keys count: $count");

    // جيب كل الـ keys
    Set<String> allKeys = sharedPreferences.getKeys();
    print("All keys set: $allKeys");

    // لو مفيش keys
    if (allKeys.isEmpty) {
      print("No keys found in SharedPreferences");
      return;
    }

    // طبع كل key مع قيمته
    print("--- All Keys and Values ---");
    for (String key in allKeys) {
      String? value = sharedPreferences.getString(key);
      print("Key: '$key' -> Value: '$value'");
    }

    // جرب تجيب كل الـ values اللي من نوع String
    print("--- Alternative method ---");
    allKeys.forEach((key) {
      var value = sharedPreferences.get(key);
      print("Key: '$key' -> Value: '$value' (Type: ${value.runtimeType})");
    });
  }
}
