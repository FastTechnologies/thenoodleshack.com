import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final http.Response response;
  final dynamic error;


  ApiResponse(this.response, this.error);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponse.withSuccess(http.Response responseValue)
      : response = responseValue,
        error = null;
}


class DioResponse {
  final Response response;
  final dynamic error;


  DioResponse(this.response, this.error);

  DioResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  DioResponse.withSuccess(Response  responseValue)
      : response = responseValue,
        error = null;
}
