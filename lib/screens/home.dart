import 'package:cryptocredit/api/chains.dart';
import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final User user;
  const HomeScreen({super.key, required this.authService, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                      width: MediaQuery.of(context).size.width * 0.8,
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

                final filteredHeaders = chainsHeaders.where((header) {
                  final headerMatch = header.title.toLowerCase().contains(
                    _searchQuery,
                  );
                  final chainMatch = header.chains.any(
                    (chain) =>
                        chain.cId.toLowerCase().contains(_searchQuery) ||
                        chain.name.toLowerCase().contains(_searchQuery) ||
                        chain.iconName.toLowerCase().contains(_searchQuery),
                  );
                  return _searchQuery.isEmpty || headerMatch || chainMatch;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search headers and chains...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                    ),

                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.deepPurple.shade800,
                              Colors.black,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.02, 0.95, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredHeaders.length,
                          itemBuilder: (context, index) {
                            final header = filteredHeaders[index];

                            final filteredChains = _searchQuery.isEmpty
                                ? header.chains
                                : header.chains
                                      .where(
                                        (chain) => chain.name
                                            .toLowerCase()
                                            .contains(_searchQuery),
                                      )
                                      .toList();

                            if (filteredChains.isEmpty &&
                                _searchQuery.isNotEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    header.title,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),

                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredChains.length,
                                  padding: const EdgeInsets.only(bottom: 8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 1,
                                      ),
                                  itemBuilder: (context, chainIndex) {
                                    final chain = filteredChains[chainIndex];
                                    return Container(
                                      height: 128,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black,
                                            Colors.black.withValues(
                                              alpha: 0.75,
                                            ),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade900
                                                .withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.grey.shade800
                                              .withValues(alpha: 0.6),
                                          width: 1.2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CryptoFontIcons.fromSymbol(
                                                  chain.iconName,
                                                ) ??
                                                Icons.diamond,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          Text(
                                            ReCase(chain.name).titleCase,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
