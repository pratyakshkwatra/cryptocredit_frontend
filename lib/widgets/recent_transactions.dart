import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/score.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cryptofont/cryptofont.dart';

import '../utils/string_utils.dart';

class RecentTransactionsList extends StatefulWidget {
  final List<Transaction> transactions;
  final Chain chain;
  final Map<String, dynamic> colors;
  final double screenWidth;
  final double borderRadius;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.chain,
    required this.colors,
    required this.screenWidth,
    required this.borderRadius,
  });

  @override
  State<RecentTransactionsList> createState() => _RecentTransactionsListState();
}

class _RecentTransactionsListState extends State<RecentTransactionsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Duration _animationDuration = Duration(milliseconds: 5000);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final tx = widget.transactions[index];
        final animationIntervalStart = index / widget.transactions.length;
        final animationIntervalEnd = (index + 1) / widget.transactions.length;

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            animationIntervalStart,
            animationIntervalEnd,
            curve: Curves.easeOut,
          ),
        );

        final displayValue =
            (tx.value! /
            BigInt.from(10).pow(tx.gasMetadata!.contractDecimals!).toDouble()).roundToDouble();

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: _buildTransactionTile(
              tx.blockHash ?? "test",
              tx.blockSignedAt!,
              "$displayValue ${widget.chain.iconName.toUpperCase()}",
              widget.colors,
              widget.screenWidth,
              widget.borderRadius,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionTile(
    String txId,
    DateTime dateTime,
    String amount,
    Map<String, dynamic> colors,
    double screenWidth,
    double borderRadius,
  ) {
    final formattedDate = DateFormat('MMM d, yyyy – hh:mm a').format(dateTime);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors["tileBackground"],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colors["tileShadow"],
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          CryptoFontIcons.eth,
          size: 20,
          color: colors["primaryColor"],
        ),
        title: Text(
          shortenAddress(txId),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.clip,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.034,
            color: colors["primaryColor"],
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: screenWidth * 0.03,
            color: colors["secondaryColor"],
          ),
        ),
        trailing: Text(
          amount,
          
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.035,
            color: colors["primaryColor"],
          ),
        ),
      ),
    );
  }
}
