import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/widgets/recent_transactions.dart';
import 'package:cryptocredit/widgets/speedometer.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../services/auth.dart';
import '../utils/color_utils.dart';
import '../widgets/top_button.dart';
import '../utils/string_utils.dart';

class ScoreScreen extends StatefulWidget {
  final AuthService authService;
  final User user;
  final String walletAddress;

  const ScoreScreen({
    super.key,
    required this.authService,
    required this.user,
    required this.walletAddress,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = getElegantColors(0);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = 12.0;

    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade600,
            child: Container(
              width: screenWidth * 0.8,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ),
      );
    }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopButton(
                    icon: CryptoFontIcons.eth,
                    colors: colors,
                    borderRadius: borderRadius,
                  ),
                  TopButton(
                    label: shortenAddress(widget.walletAddress),
                    colors: colors,
                    borderRadius: borderRadius,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: Speedometer(
                  size: screenWidth * 0.7,
                  score: 0,
                  colors: colors,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: colors["primaryColor"],
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Expanded(
                child: RecentTransactionsList(
                  transactions: [],
                  colors: colors,
                  screenWidth: screenWidth,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
