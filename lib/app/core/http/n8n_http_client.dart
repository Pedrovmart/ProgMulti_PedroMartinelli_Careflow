import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class N8nHttpClient {
  final Dio _dio;
  final String _baseUrl;
  
  String get baseUrl => _baseUrl;
  final String _username;
  final String _password;

  N8nHttpClient({
    Dio? dio,
    String? baseUrl,
    String? username,
    String? password,
  })  : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? dotenv.env['BASE_URL'] ?? '',
        _username = username ?? dotenv.env['BASIC_AUTH_USERNAME'] ?? '',
        _password = password ?? dotenv.env['BASIC_AUTH_PASSWORD'] ?? '' {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.responseType = ResponseType.json; 
    _dio.options.connectTimeout = const Duration(seconds: 3000); 
    _dio.options.receiveTimeout = const Duration(seconds: 3000); 
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final credentials = '$_username:$_password';
          final base64Credentials = base64Encode(utf8.encode(credentials));
          options.headers['Authorization'] = 'Basic $base64Credentials';
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json'; 
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.data is String) {
            try {
              response.data = json.decode(response.data);
            } catch (e) {
              //tratamento no repository
            }
          }
          return handler.next(response);
        },
      ),
    );
    
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(
      path, 
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
