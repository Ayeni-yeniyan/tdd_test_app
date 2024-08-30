import 'package:dio/dio.dart';

class RestClient {
  Dio get dio {
    return Dio(BaseOptions(
      baseUrl: 'http://numbersapi.com',
      contentType: 'application/json',
    ));
  }
}
