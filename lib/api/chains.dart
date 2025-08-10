import 'package:cryptocredit/api/api_client.dart';
import 'package:cryptocredit/api/models/chain.dart';
import 'package:dio/dio.dart';

class ChainsAPI {
  final Dio _dio = ApiClient().dio;

  ChainsAPI();

  Future<List<ChainHeader>> getChains() async {
    try {
      final response = await _dio.get('/chains');
      final data = response.data as Map<String, dynamic>;

      List<ChainHeader> headers = data.entries.map((entry) {
        final title = entry.key;
        final chainsMap = entry.value as Map<String, dynamic>;

        List<Chain> chainsList = chainsMap.entries
            .map((chainEntry) => Chain.fromMapEntry(chainEntry))
            .toList();

        return ChainHeader(title: title, chains: chainsList);
      }).toList();

      return headers;
    } on DioException catch (e) {
      throw Exception('Failed to load chains: ${e.message}');
    }
  }
}
