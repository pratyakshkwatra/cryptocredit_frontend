import 'package:cryptocredit/api/chains.dart';
import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final User user;
  const HomeScreen({super.key, required this.authService, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6A11CB);

    List<Color> backgroundGradient = [
      const Color(0xFF2D1B4E),
      const Color(0xFF1A102F),
      Colors.black,
    ];

    double screenWidth = MediaQuery.of(context).size.width;

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
          bottom: false,
          child: FutureBuilder<List<ChainHeader>>(
            future: ChainsAPI().getChains(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xFF1A102F),
                    highlightColor: const Color(0xFF3E2C72),
                    child: Container(
                      width: screenWidth * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D1B4E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              } else {
                final chainsHeaders = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  itemCount: chainsHeaders.length,
                  itemBuilder: (context, index) {
                    final header = chainsHeaders[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Title with reduced vertical padding
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ), // was 8
                          child: Text(
                            header.title,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),

                        // GridView of Chains for this header
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: header.chains.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3,
                              ),
                          itemBuilder: (context, chainIndex) {
                            final chain = header.chains[chainIndex];
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withValues(alpha: 0.85),
                                    Colors.deepPurple.withValues(alpha: 0.75),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.deepPurple.withValues(alpha: 0.9),
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),

                              alignment: Alignment.centerLeft,
                              child: Text(
                                chain.chainLongName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12), // was 24
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
