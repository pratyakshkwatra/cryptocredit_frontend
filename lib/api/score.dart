
import 'package:cryptocredit/api/api_client.dart';
import 'package:cryptocredit/api/models/score.dart';
import 'package:dio/dio.dart';

class ScoreAPI {
  final Dio _dio = ApiClient().dio;

  ScoreAPI();

  Future<Score> getScore({
    required String chain,
    required String address,
    required String accessToken,
  }) async {
    try {
      final response = await _dio.post(
        '/score/',
        data: {'address': address, 'chain': chain, 'tx_limit': 10},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final data = response.data;
      return Score.fromMap(data);
    } on DioException catch (e) {
      throw Exception('Failed to load score: ${e.message}');
    }
  }
}
