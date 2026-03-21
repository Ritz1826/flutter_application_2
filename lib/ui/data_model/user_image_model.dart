import 'dart:convert';

UsersImage usersImageFromJson(String str) =>
    UsersImage.fromJson(json.decode(str));

String usersImageToJson(UsersImage data) => json.encode(data.toJson());

class UsersImage {
  String originalname;
  String filename;
  String location;

  UsersImage({
    required this.originalname,
    required this.filename,
    required this.location,
  });

  factory UsersImage.fromJson(Map<String, dynamic> json) => UsersImage(
    originalname: json["originalname"],
    filename: json["filename"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "originalname": originalname,
    "filename": filename,
    "location": location,
  };
}
