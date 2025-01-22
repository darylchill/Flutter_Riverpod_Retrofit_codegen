import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage/secureStorage.dart';

TokenStorage tokenStorage = TokenStorage();

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    sendTimeout: Duration(seconds: 5),
    baseUrl: 'http://192.168.1.12/product_api/public/api/', // Replace with your API URL
    headers: {
      'Content-Type': 'application/json', // Add Content-Type header globally
      'Accept': 'application/json',
    },
  ));

  // Add an interceptor to include Bearer token dynamically
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Retrieve token from secure storage
      final token = await TokenStorage.getToken();
      debugPrint('Token: $token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options); // Continue the request
    },
  ));

  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    responseHeader: false,
    request: true,
    requestBody: true,
  ));

  return dio;
});