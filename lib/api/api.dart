import 'package:cryptocredit/api/api_client.dart';
import 'package:cryptocredit/api/models/api_key.dart';
import 'package:cryptocredit/api/models/api_analytics.dart';
import 'package:dio/dio.dart';

class APIAPI {
  final Dio _dio = ApiClient().dio;

  APIAPI();

  Future<List<APIKey>> getAPIKeys(String accessToken) async {
    try {
      final response = await _dio.get(
        '/api/keys',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final List keys = response.data['api_keys'];
      return keys.map((e) => APIKey.fromMap(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load API keys: ${e.message}');
    }
  }

  Future<APIKey> createAPIKey(String name, String accessToken) async {
    try {
      final response = await _dio.post(
        '/api/keys',
        queryParameters: {'name': name},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return APIKey.fromMap(response.data['api_key']);
    } on DioException catch (e) {
      throw Exception('Failed to create API key: ${e.message}');
    }
  }

  Future<void> deleteAPIKey(int keyId, String accessToken) async {
    try {
      await _dio.delete(
        '/api/keys/$keyId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete API key: ${e.message}');
    }
  }

  Future<APIAnalytics> getOverallAnalytics(String accessToken) async {
    try {
      final response = await _dio.get(
        '/api/analytics',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return APIAnalytics.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load analytics: ${e.message}');
    }
  }

  Future<APIAnalytics?> getKeyAnalytics(int keyId, String accessToken) async {
    try {
      final response = await _dio.get(
        '/api/analytics/$keyId',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return APIAnalytics.fromMap(response.data);
    } on DioException catch (_) {
      return null;
    }
  }
}
