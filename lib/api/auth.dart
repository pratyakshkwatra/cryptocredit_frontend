import 'dart:developer';

import 'package:cryptocredit/api/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';
import 'exceptions.dart';

class AuthAPI {
  final _dio = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<User> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/sign_in',
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      final user = User.fromJson(data);

      await _storage.write(key: 'access_token', value: user.accessToken);
      await _storage.write(key: 'refresh_token', value: user.refreshToken);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw APIException('Invalid credentials', e.response!.statusCode);
      }

      throw APIException(
        e.message ?? 'An Error Occurred',
        e.response!.statusCode,
      );
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _dio.post(
        '/auth/sign_up',
        data: {'email': email, 'password': password},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw APIException('email already exists', e.response!.statusCode);
      }
      throw APIException(
        e.message ?? 'An Error Occurred',
        e.response!.statusCode,
      );
    }
  }

  Future<User> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh_token',
        data: {'refresh_token': refreshToken},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException('Session expired');
      }
      throw APIException(e.message ?? 'Token refresh failed');
    }
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(
      '/auth/sign_out',
      data: {'refresh_token': refreshToken},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    await _storage.deleteAll();
  }
}
