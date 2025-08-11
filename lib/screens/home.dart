import 'package:cryptocredit/api/chains.dart';
import 'package:cryptocredit/api/models/chain.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/screens/wallets.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:cryptofont/cryptofont.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final User user;
  const HomeScreen({super.key, required this.authService, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = [
      const Color(0xFF2D1B4E),
      const Color(0xFF1A102F),
      const Color.fromARGB(255, 11, 10, 15),
      const Color.fromARGB(255, 17, 13, 27),
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
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: const Color(0xFF6A11CB),
                    strokeCap: StrokeCap.round,
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
                            stops: const [0.0, 0.01, 0.95, 1.0],
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

                            final double headerStart =
                                index / filteredHeaders.length;
                            final double headerEnd =
                                (index + 1) / filteredHeaders.length;

                            final headerAnimation = CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                headerStart,
                                headerEnd,
                                curve: Curves.easeOut,
                              ),
                            );

                            return FadeTransition(
                              opacity: headerAnimation,
                              child: Column(
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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

                                      final double itemStart =
                                          headerStart +
                                          (headerEnd - headerStart) *
                                              (chainIndex /
                                                  filteredChains.length);
                                      final double itemEnd =
                                          headerStart +
                                          (headerEnd - headerStart) *
                                              ((chainIndex + 1) /
                                                  filteredChains.length);

                                      final itemAnimation = CurvedAnimation(
                                        parent: _animationController,
                                        curve: Interval(
                                          itemStart.clamp(0.0, 1.0),
                                          itemEnd.clamp(0.0, 1.0),
                                          curve: Curves.easeOut,
                                        ),
                                      );

                                      return FadeTransition(
                                        opacity: itemAnimation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.2),
                                            end: Offset.zero,
                                          ).animate(itemAnimation),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return WalletsScreen(
                                                      authService:
                                                          widget.authService,
                                                      chain: chain,
                                                      user: widget.user,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 128,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1C1C1C),
                                                borderRadius:
                                                    BorderRadius.circular(16),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 16,
                                                  ),
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
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
                                                    ReCase(
                                                      chain.name,
                                                    ).titleCase,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),
                                ],
                              ),
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
