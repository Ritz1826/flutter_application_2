import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   handler.next(response);
    // } else {
    //   handler.reject(
    //     DioException(requestOptions: response.requestOptions),
    //     true,
    //   );
    // }

    // super.onResponse(response, handler);
  }
}
