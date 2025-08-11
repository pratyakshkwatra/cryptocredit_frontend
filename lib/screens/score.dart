import 'dart:async';

import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/score.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/api/models/wallet.dart';
import 'package:cryptocredit/api/score.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:cryptocredit/widgets/dialog.dart';
import 'package:cryptocredit/widgets/recent_transactions.dart';
import 'package:cryptocredit/widgets/speedometer.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/color_utils.dart';
import '../widgets/top_button.dart';
import '../utils/string_utils.dart';

class ScoreScreen extends StatefulWidget {
  final AuthService authService;
  final User user;
  final Chain chain;
  final Wallet wallet;

  const ScoreScreen({
    super.key,
    required this.authService,
    required this.user,
    required this.chain,
    required this.wallet,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  late Future<Score> _scoreFuture;
  Map<String, dynamic> colors = getElegantColors(0);

  @override
  void initState() {
    super.initState();
    _scoreFuture = ScoreAPI()
        .getScore(
          chain: widget.chain.cId,
          address: widget.wallet.address,
          accessToken: widget.user.accessToken!,
        )
        .then((score) {
          colors = getElegantColors(score.creditScore);
          setState(() {});

          return score;
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = 12.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: List<Color>.from(colors["gradientColors"]),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: SafeArea(
          child: FutureBuilder<Score>(
            future: _scoreFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: colors["primaryColor"],
                    strokeCap: StrokeCap.round,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading score: ${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.hasData) {
                final score = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            int pops = 0;
                            Navigator.of(
                              context,
                            ).popUntil((route) => pops++ == 2);
                          },
                          child: TopButton(
                            icon:
                                CryptoFontIcons.fromSymbol(
                                  widget.chain.iconName,
                                ) ??
                                Icons.diamond,
                            colors: colors,
                            borderRadius: borderRadius,
                            dense: false,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            int pops = 0;
                            Navigator.of(
                              context,
                            ).popUntil((route) => pops++ == 1);
                          },
                          child: TopButton(
                            label: shortenAddress(widget.wallet.address),
                            colors: colors,
                            borderRadius: borderRadius,
                            dense: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: Speedometer(
                        size: screenWidth * 0.7,
                        score: score.creditScore,
                        colors: colors,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                            color: colors["primaryColor"],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDataDialog(
                              context,
                              colors,
                              score,
                              widget.chain,
                            );
                          },
                          child: TopButton(
                            colors: colors,
                            borderRadius: 12,
                            label: "Analytics",
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    score.transactions.isNotEmpty
                        ? Expanded(
                            child: RecentTransactionsList(
                              transactions: score.transactions,
                              chain: widget.chain,
                              colors: colors,
                              screenWidth: screenWidth,
                              borderRadius: borderRadius,
                            ),
                          )
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: colors["primaryColor"].withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: colors["primaryColor"]
                                            .withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet_outlined,
                                          size: 64,
                                          color: colors["primaryColor"]
                                              .withValues(alpha: 0.75),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No transactions found',
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: colors["primaryColor"]
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
