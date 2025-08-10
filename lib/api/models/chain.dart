class Chain {
  final String chainShortName;
  final String chainLongName;

  Chain({
    required this.chainShortName,
    required this.chainLongName,
  });

  factory Chain.fromMapEntry(MapEntry<String, dynamic> entry) {
    return Chain(
      chainShortName: entry.key,
      chainLongName: entry.value.toString(),
    );
  }
}

class ChainHeader {
  final String title;
  final List<Chain> chains;

  ChainHeader({
    required this.title,
    required this.chains,
  });
}
