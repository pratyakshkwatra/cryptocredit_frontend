class Score {
  final int creditScore;
  final Details details;
  final List<Transaction> transactions;

  Score({
    required this.creditScore,
    required this.details,
    required this.transactions,
  });

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      creditScore: map['credit_score']?.toInt() ?? 0,
      details: Details.fromMap(map['details'] ?? {}),
      transactions: map['transactions'] != null
          ? (map['transactions'] as List<dynamic>)
                .map((x) => Transaction.fromMap(x as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class Details {
  final TxQuality txQuality;
  final Diversification diversification;
  final WalletAge walletAge;
  final GasUsage gasUsage;
  final LiquidityLockup liquidityLockup;

  Details({
    required this.txQuality,
    required this.diversification,
    required this.walletAge,
    required this.gasUsage,
    required this.liquidityLockup,
  });

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      txQuality: TxQuality.fromMap(map['tx_quality'] ?? {}),
      diversification: Diversification.fromMap(map['diversification'] ?? {}),
      walletAge: WalletAge.fromMap(map['wallet_age'] ?? {}),
      gasUsage: GasUsage.fromMap(map['gas_usage'] ?? {}),
      liquidityLockup: LiquidityLockup.fromMap(map['liquidity_lockup'] ?? {}),
    );
  }
}

class TxQuality {
  final Map<String, int> frequencyPerYear;
  final Map<String, int> frequencyPerMonth;
  final double failureRate;
  final double avgTxValue;

  TxQuality({
    required this.frequencyPerYear,
    required this.frequencyPerMonth,
    required this.failureRate,
    required this.avgTxValue,
  });

  factory TxQuality.fromMap(Map<String, dynamic> map) {
    return TxQuality(
      frequencyPerYear:
          (map['frequency_per_year'] as Map<String, dynamic>?)
              ?.cast<String, int>() ??
          {},
      frequencyPerMonth:
          (map['frequency_per_month'] as Map<String, dynamic>?)
              ?.cast<String, int>() ??
          {},
      failureRate: map['failure_rate']?.toDouble() ?? 0.0,
      avgTxValue: map['avg_tx_value']?.toDouble() ?? 0.0,
    );
  }
}

class Diversification {
  final int uniqueTokensHeld;
  final int uniqueToAddresses;

  Diversification({
    required this.uniqueTokensHeld,
    required this.uniqueToAddresses,
  });

  factory Diversification.fromMap(Map<String, dynamic> map) {
    return Diversification(
      uniqueTokensHeld: map['unique_tokens_held'] ?? 0,
      uniqueToAddresses: map['unique_to_addresses'] ?? 0,
    );
  }
}

class WalletAge {
  final int walletAgeDays;
  final int dormantMonths;
  final double activityBurstPenalty;

  WalletAge({
    required this.walletAgeDays,
    required this.dormantMonths,
    required this.activityBurstPenalty,
  });

  factory WalletAge.fromMap(Map<String, dynamic> map) {
    return WalletAge(
      walletAgeDays: map['wallet_age_days'] ?? 0,
      dormantMonths: map['dormant_months'] ?? 0,
      activityBurstPenalty: map['activity_burst_penalty']?.toDouble() ?? 0.0,
    );
  }
}

class GasUsage {
  final double avgGasPrice;
  final double medianGasPrice;
  final double gasPriceRatio;

  GasUsage({
    required this.avgGasPrice,
    required this.medianGasPrice,
    required this.gasPriceRatio,
  });

  factory GasUsage.fromMap(Map<String, dynamic> map) {
    return GasUsage(
      avgGasPrice: map['avg_gas_price']?.toDouble() ?? 0.0,
      medianGasPrice: map['median_gas_price']?.toDouble() ?? 0.0,
      gasPriceRatio: map['gas_price_ratio']?.toDouble() ?? 0.0,
    );
  }
}

class LiquidityLockup {
  final double totalBalance;
  final double liquidBalance;
  final double lockedUpBalance;
  final double lockupRatio;

  LiquidityLockup({
    required this.totalBalance,
    required this.liquidBalance,
    required this.lockedUpBalance,
    required this.lockupRatio,
  });

  factory LiquidityLockup.fromMap(Map<String, dynamic> map) {
    return LiquidityLockup(
      totalBalance: map['total_balance']?.toDouble() ?? 0.0,
      liquidBalance: map['liquid_balance']?.toDouble() ?? 0.0,
      lockedUpBalance: map['locked_up_balance']?.toDouble() ?? 0.0,
      lockupRatio: map['lockup_ratio']?.toDouble() ?? 0.0,
    );
  }
}

class Transaction {
  final DateTime? blockSignedAt;
  final int? blockHeight;
  final String? blockHash;
  final String? txHash;
  final int? txOffset;
  final bool? successful;
  final String? fromAddress;
  final String? fromAddressLabel;
  final String? toAddress;
  final String? toAddressLabel;
  final double? value;
  final double? valueQuote;
  final String? prettyValueQuote;
  final int? gasOffered;
  final int? gasSpent;
  final int? gasPrice;
  final int? feesPaid;
  final double? gasQuote;
  final String? prettyGasQuote;
  final double? gasQuoteRate;
  final GasMetadata? gasMetadata;

  Transaction({
    this.blockSignedAt,
    this.blockHeight,
    this.blockHash,
    this.txHash,
    this.txOffset,
    this.successful,
    this.fromAddress,
    this.fromAddressLabel,
    this.toAddress,
    this.toAddressLabel,
    this.value,
    this.valueQuote,
    this.prettyValueQuote,
    this.gasOffered,
    this.gasSpent,
    this.gasPrice,
    this.feesPaid,
    this.gasQuote,
    this.prettyGasQuote,
    this.gasQuoteRate,
    this.gasMetadata,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      blockSignedAt: map['block_signed_at'] != null
          ? DateTime.parse(map['block_signed_at'])
          : null,
      blockHeight: map['block_height'],
      blockHash: map['block_hash'],
      txHash: map['tx_hash'],
      txOffset: map['tx_offset'],
      successful: map['successful'],
      fromAddress: map['from_address'],
      fromAddressLabel: map['from_address_label'],
      toAddress: map['to_address'],
      toAddressLabel: map['to_address_label'],
      value: map['value'] != null
          ? double.tryParse(map['value'].toString())
          : null,
      valueQuote: map['value_quote']?.toDouble(),
      prettyValueQuote: map['pretty_value_quote'],
      gasOffered: int.tryParse(map['gas_offered']?.toString() ?? ''),
      gasSpent: int.tryParse(map['gas_spent']?.toString() ?? ''),
      gasPrice: int.tryParse(map['gas_price']?.toString() ?? ''),
      feesPaid: int.tryParse(map['fees_paid']?.toString() ?? ''),
      gasQuote: map['gas_quote']?.toDouble(),
      prettyGasQuote: map['pretty_gas_quote'],
      gasQuoteRate: map['gas_quote_rate']?.toDouble(),
      gasMetadata: map['gas_metadata'] != null
          ? GasMetadata.fromMap(map['gas_metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}

class GasMetadata {
  final int? contractDecimals;
  final String? contractTickerSymbol;
  final String? logoUrl;

  GasMetadata({this.contractDecimals, this.contractTickerSymbol, this.logoUrl});

  factory GasMetadata.fromMap(Map<String, dynamic> map) {
    return GasMetadata(
      contractDecimals: map['contract_decimals'],
      contractTickerSymbol: map['contract_ticker_symbol'],
      logoUrl: map['logo_url'],
    );
  }
}
