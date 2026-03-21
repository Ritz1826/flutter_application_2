import 'package:flutter_application_2/ui/core/dio_core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_2/ui/data_model/university_data_model.dart';

class UniversitydataApihelper {
  DioClient dioClient = DioClient();

  Future<void> getUniversityData(int skip) async {
    try {
      dioClient.dio.options.baseUrl = "https://dummyjson.com";

      Map<String, dynamic> queryParams = {"skip": skip, "limit": 10};

      Response response = await dioClient.dioGet(
        "/users",
        queryParams: queryParams,
      );
      print("i am hereee");
      UniversityData result = UniversityData.fromJson(response.data);
      print("i am hereee 2");

      print("totallll" + result.total.toString());
    } catch (e) {
      print(e);
      // rethrow;
    }
  }
}
