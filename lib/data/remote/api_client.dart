// lib/data/remote/api_client.dart
// ROADSoS - API Client (Dio Singleton)

import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://roadsos-backend.up.railway.app/api/v1';
  
  static final ApiClient instance = ApiClient._init();
  late final Dio _dio;

  ApiClient._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          final errorMessage = _mapDioErrorToMessage(e);
          // Pass the mapped string down so consumers can catch it directly
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: 'Network error: $errorMessage',
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  String _mapDioErrorToMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response!.data.toString();
    }
    return e.message ?? 'Unknown network failure';
  }

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw e.error as String;
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw e.error as String;
    } catch (e) {
      throw 'Network error: $e';
    }
  }
}
