import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/api/models/wallet.dart';
import 'package:cryptocredit/api/wallets.dart';
import 'package:cryptocredit/screens/add_wallet.dart';
import 'package:cryptocredit/screens/score.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:cryptocredit/utils/string_utils.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletsScreen extends StatefulWidget {
  final AuthService authService;
  final Chain chain;
  final User user;

  const WalletsScreen({
    super.key,
    required this.authService,
    required this.chain,
    required this.user,
  });

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = [
      const Color(0xFF2D1B4E),
      const Color(0xFF1A102F),
      Colors.black,
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 6,
                          bottom: 6,
                          left: 6,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _animationController.forward(from: 0.0);
                        });
                      },
                      child: const RotatingIcon(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: FutureBuilder<List<Wallet>>(
                  future: WalletsAPI().getWallets(chain: widget.chain.cId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          color: Color(0xFF6A11CB),
                          strokeCap: StrokeCap.round,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final List<Wallet> wallets = snapshot.data ?? [];
                    if (wallets.isNotEmpty &&
                        !_animationController.isAnimating &&
                        !_animationController.isCompleted) {
                      _animationController.forward();
                    }

                    if (wallets.isEmpty) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 64,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No wallets found',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a wallet to get started.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        final Wallet wallet = wallets[index];

                        final double start = index / wallets.length;
                        final double end = (index + 1) / wallets.length;

                        final animation = Tween<double>(begin: 0.0, end: 1.0)
                            .animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  start,
                                  end,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: ListTile(
                                title: Text(
                                  wallet.nickname,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  shortenAddress(wallet.address),
                                  style: GoogleFonts.inter(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                leading: Icon(
                                  CryptoFontIcons.fromSymbol(
                                        widget.chain.iconName,
                                      ) ??
                                      Icons.diamond,
                                  color: Colors.white70,
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    await WalletsAPI().deleteWallet(wallet.id);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent.shade200.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ScoreScreen(
                                          authService: widget.authService,
                                          chain: widget.chain,
                                          user: widget.user,
                                          wallet: wallet,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E4AE1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    icon: const Icon(Icons.add, size: 24, color: Colors.black),
                    label: Text(
                      'Add Wallet',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddWalletScreen(
                              chain: widget.chain,
                              user: widget.user,
                            );
                          },
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RotatingIcon extends StatefulWidget {
  const RotatingIcon({super.key});

  @override
  State<RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon> {
  double _rotationTurns = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rotationTurns += 1;
        });
      },
      child: AnimatedRotation(
        turns: _rotationTurns,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
