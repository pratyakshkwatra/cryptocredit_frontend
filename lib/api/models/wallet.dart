import 'dart:convert';

class Wallet {
  final int id;
  final int walletId;

  Wallet({
    required this.id,
    required this.walletId,
  });

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id']?.toInt() ?? 0,
      walletId: map['wallet_id']?.toInt() ?? 0,
    );
  }

  factory Wallet.fromJson(String source) => Wallet.fromMap(json.decode(source));
}
