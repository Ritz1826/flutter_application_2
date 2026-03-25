import 'package:flutter_application_2/ui/core/dio_core/dio_client.dart';
import 'package:flutter_application_2/ui/data_model/pagination_model.dart';
import 'package:flutter_application_2/ui/data_model/userImages_data_model.dart';

class UserimagesApihelper {
  final DioClient _dioClient = DioClient();

  Future<PaginationModel2> getUserImages({String? query, int page = 1}) async {
    try {
      _dioClient.dio.options.baseUrl = "https://api.openverse.org/";

      print("the query $query");

      Map<String, dynamic> queryParams = {
        "q": query,
        "page": page,
        "page_size": 10,
      };

      final response = await _dioClient.dioGet(
        "v1/images/",
        queryParams: queryParams,
      );

      final UserImages parsedResponse = UserImages.fromJson(response.data);

      bool hasNextPage = parsedResponse.page < parsedResponse.pageCount;

      final result = PaginationModel2<UserImageData>(
        userData: parsedResponse.results,
        currentPage: parsedResponse.page,
        pageCount: parsedResponse.pageCount,
        hasNextPage: hasNextPage,
      );

      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
