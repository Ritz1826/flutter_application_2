import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late Dio dio;

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://jsonplaceholder.typicode.com",
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        connectTimeout: Duration(microseconds: 0),
        receiveTimeout: Duration(microseconds: 0),
      ),
    );

    dio.interceptors.addAll([
      // PrettyDioLogger(requestBody: true, responseBody: true),
    ]);
  }

  Future<Response> dioGet(
    String apiUrl, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await dio.get(apiUrl, queryParameters: queryParams);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> dipPost(
    String apiUrl, {
    Map<String, dynamic>? body,
    FormData? data,
  }) async {
    try {
      Response response = await dio.post(apiUrl, data: data ?? body);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
