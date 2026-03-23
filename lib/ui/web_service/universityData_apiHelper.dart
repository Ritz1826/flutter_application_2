import 'package:flutter_application_2/ui/core/dio_core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_2/ui/data_model/pagination_model.dart';
import 'package:flutter_application_2/ui/data_model/university_data_model.dart';

class UniversitydataApihelper {
  DioClient dioClient = DioClient();

  Future<PaginationModel<User>> getUniversityData(int skip) async {
    try {
      print("api called");

      dioClient.dio.options.baseUrl = "https://dummyjson.com";

      Map<String, dynamic> queryParams = {"skip": skip, "limit": 20};

      Response response = await dioClient.dioGet(
        "/users",
        queryParams: queryParams,
      );

      UniversityData result = UniversityData.fromJson(response.data);

      bool hasNextPage = result.skip < result.total;

      PaginationModel<User> data = PaginationModel(
        userData: result.users,
        limit: result.limit,
        skip: result.skip,
        hasNextPage: hasNextPage,
      );

      return data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
