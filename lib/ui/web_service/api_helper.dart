import 'dart:convert';
import 'package:flutter_application_2/ui/core/dio_core/dio_client.dart';
import 'package:flutter_application_2/ui/data_model/user_image_model.dart';
import 'package:flutter_application_2/ui/data_model/user_posts_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

final DioClient dioClient = DioClient();

Future<List<UsersPosts>> getPosts() async {
  // try {
  //   var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  //   var response = await http
  //       .get(url, headers: {"Content-Type": "application/json"})
  //       .timeout(Duration(seconds: 5));

  //   print("type" + response.body.runtimeType.toString());

  //   if (response.statusCode == 200) {
  //     List<UsersPosts> result = usersPostsFromJson(response.body);

  //     print(result.runtimeType);
  //     return result;
  //   } else {
  //     throw Exception("Something went wrong");
  //   }
  // } catch (e) {
  //   print("error");gg
  //   rethrow;
  // }

  try {
    Response response = await dioClient.dioGet("/posts");
    List<UsersPosts> result = (response.data as List)
        .map((e) => UsersPosts.fromJson(e))
        .toList();
    return result;
  } catch (e) {
    print("error");
    rethrow;
  }
}

Future<void> setTitle(String? title) async {
  // try {
  //   var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  //   var response = await http.post(
  //     url,
  //     // headers: {"Content-Type": "application/json"},
  //     body: {"title": title},
  //   );

  //   print("object");

  //   if (response.statusCode == 201) {
  //     print("heree");
  //     var result = jsonDecode(response.body);
  //     print(result.toString());
  //   } else {
  //     print(response.statusCode);
  //   }
  // } catch (e) {
  //   print(e);
  //   rethrow;
  // }

  try {
    Map<String, dynamic> body = {"title": title};
    Response response = await dioClient.dipPost("/posts", body: body);

    print(response.data.toString());
  } catch (e) {
    print("errorrrrr " + e.toString());
    rethrow;
  }
}

Future<String> postImage(XFile? file, String? path) async {
  // try {
  //   var url = Uri.parse("https://api.escuelajs.co/api/v1/files/upload");

  //   var response = http.MultipartRequest("POST", url);

  //   response.files.add(await http.MultipartFile.fromPath("file", path ?? ""));

  //   var x = await response.send();

  //   print("img reponseeee" + response.toString());
  //   print(
  //     "img reponseeee 1" +
  //         jsonDecode(await x.stream.bytesToString()).toString(),
  //   );
  // } catch (e) {
  //   print(e);
  //   rethrow;
  // }

  try {
    dioClient.dio.options.baseUrl = "https://api.escuelajs.co/api/v1";

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(path ?? "", filename: "abc.png"),
    });

    Response response = await dioClient.dipPost("/files/upload", data: data);

    UsersImage result = UsersImage.fromJson(response.data);

    String img = result.location;

    return img;
  } catch (e) {
    print("img errorrr" + e.toString());
    rethrow;
  }
}
