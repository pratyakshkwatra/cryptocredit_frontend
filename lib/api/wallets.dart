
import 'package:cryptocredit/api/api_client.dart';
import 'package:cryptocredit/api/models/wallet.dart';
import 'package:dio/dio.dart';

class WalletsAPI {
  final Dio _dio = ApiClient().dio;

  WalletsAPI();

  Future<List<Wallet>> getWallets({required String chain}) async {
    try {
      final response = await _dio.get(
        '/wallets/',
        queryParameters: {'chain': chain},
      );

      final data = response.data as List<dynamic>;
      return data.map((json) => Wallet.fromMap(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load wallets: ${e.message}');
    }
  }

  Future<Wallet> addWallet(String address, String chain, String nickname, String accessToken) async {
    try {
      final response = await _dio.post(
        '/wallets/',
        data: {'address': address, 'chain': chain, "nickname": nickname},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );


      return Wallet.fromMap(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to add wallet: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> verifyWallet(
    String address,
    String chain,
    String accessToken,
    String nickname,
  ) async {
    try {
      final response = await _dio.post(
        '/wallets/verify',
        data: {'address': address, 'chain': chain, "nickname": nickname},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (_) {
      return {"message": "Unknown error...", "error": true};
    }
  }

  Future<void> deleteWallet(int walletId) async {
    try {
      await _dio.delete('/wallets/$walletId');
    } on DioException catch (e) {
      throw Exception('Failed to delete wallet: ${e.message}');
    }
  }
}
