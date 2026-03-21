// To parse this JSON data, do
//
//     final usersPosts = usersPostsFromJson(jsonString);

import 'dart:convert';

List<UsersPosts> usersPostsFromJson(String str) =>
    List<UsersPosts>.from(json.decode(str).map((x) => UsersPosts.fromJson(x)));

String usersPostsToJson(List<UsersPosts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersPosts {
  int userId;
  int id;
  String title;
  String body;

  UsersPosts({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory UsersPosts.fromJson(Map<String, dynamic> json) => UsersPosts(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
