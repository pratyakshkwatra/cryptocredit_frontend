import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cryptofont/cryptofont.dart';

import '../utils/string_utils.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Map<String, dynamic> colors;
  final double screenWidth;
  final double borderRadius;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.colors,
    required this.screenWidth,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return _buildTransactionTile(
          tx["txId"],
          tx["dateTime"],
          tx["amount"],
          colors,
          screenWidth,
          borderRadius,
        );
      },
    );
  }

  Widget _buildTransactionTile(
    String txId,
    DateTime dateTime,
    double amount,
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
          amount.toStringAsFixed(4),
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
