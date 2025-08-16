import 'package:cryptocredit/api/api.dart';
import 'package:cryptocredit/api/models/api_key.dart';
import 'package:cryptocredit/api/models/api_analytics.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class APIKeysScreen extends StatefulWidget {
  final User user;
  const APIKeysScreen({super.key, required this.user});

  @override
  State<APIKeysScreen> createState() => _APIKeysScreenState();
}

class _APIKeysScreenState extends State<APIKeysScreen> {
  final APIAPI _api = APIAPI();

  late Future<List<APIKey>> _futureKeys;
  late Future<APIAnalytics> _futureAnalytics;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureKeys = _api.getAPIKeys(widget.user.accessToken!);
    _futureAnalytics = _api.getOverallAnalytics(widget.user.accessToken!);
  }

  void _showCreateKeyDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1E1E2C), const Color(0xFF2A2A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Create API Key",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter a name to identify this key",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                _RoundedInputField(
                  controller: controller,
                  hintText: "e.g. My Trading Bot",
                  icon: Icons.vpn_key,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A11CB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        if (controller.text.isEmpty) return;

                        try {
                          final apiKey = await _api.createAPIKey(
                            controller.text,
                            widget.user.accessToken!,
                          );

                          if (context.mounted) {
                            await _showCreatedKeyDialog(context, apiKey.key);
                          }
                          setState(() => _loadData());
                        } catch (e) {
                          if (context.mounted) _showError("Failed: $e");
                        }
                      },
                      child: Text(
                        "Create",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCreatedKeyDialog(BuildContext context, String key) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E1E2C), const Color(0xFF2A2A3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "API Key Created",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Copy and save this key, it will not be shown again:",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  key,
                  style: GoogleFonts.robotoMono(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.withValues(alpha: 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: key));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Copied to clipboard",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, color: Colors.greenAccent),
                label: Text(
                  "Copy Key",
                  style: GoogleFonts.poppins(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _deleteKey(int id) async {
    try {
      await _api.deleteAPIKey(id, widget.user.accessToken!);
      setState(() => _loadData());
    } catch (e) {
      if (mounted) _showError("Failed to delete key: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> backgroundGradient = [
      const Color(0xFF2D1B4E),
      const Color(0xFF1A102F),
      Colors.black,
    ];

    return Scaffold(
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
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              FutureBuilder<APIAnalytics>(
                future: _futureAnalytics,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  final analytics = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _analyticsBox(
                          context,
                          "Total Calls",
                          NumberFormat.compact().format(analytics.totalCalls),
                        ),
                        _analyticsBox(
                          context,
                          "Success",
                          NumberFormat.compact().format(analytics.totalSuccess),
                        ),
                        _analyticsBox(
                          context,
                          "Errors",
                          NumberFormat.compact().format(analytics.totalErrors),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: FutureBuilder<List<APIKey>>(
                  future: _futureKeys,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    final keys = snapshot.data!;
                    if (keys.isEmpty) {
                      return Center(
                        child: Text(
                          "No API keys found",
                          style: GoogleFonts.poppins(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        return Card(
                          color: Colors.white.withValues(alpha: 0.05),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                collapsedIconColor: Colors.white70,
                                iconColor: Colors.white,
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),

                                childrenPadding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                collapsedBackgroundColor: Colors.white
                                    .withValues(alpha: 0.05),
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.05,
                                ),
                                title: Text(
                                  key.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _deleteKey(key.id),
                                ),
                                children: [
                                  FutureBuilder<APIAnalytics?>(
                                    future: _api.getKeyAnalytics(
                                      key.id,
                                      widget.user.accessToken!,
                                    ),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      }

                                      final stats = snap.data;
                                      final total = (stats?.totalCalls ?? 0);
                                      final success =
                                          (stats?.totalSuccess ?? 0);
                                      final errors = (stats?.totalErrors ?? 0);

                                      if (total == 0 &&
                                          success == 0 &&
                                          errors == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.insights_outlined,
                                                size: 40,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                "No analytics yet",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Start using this API key to see analytics.",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        child: SizedBox(
                                          height: 200,
                                          child: BarChart(
                                            BarChartData(
                                              gridData: FlGridData(show: false),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              alignment:
                                                  BarChartAlignment.spaceAround,
                                              titlesData: FlTitlesData(
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: false,
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    reservedSize: 28,
                                                    getTitlesWidget: (value, meta) {
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          return Text(
                                                            "Total",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          );
                                                        case 1:
                                                          return Text(
                                                            "Success",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          );
                                                        case 2:
                                                          return Text(
                                                            "Errors",
                                                            style:
                                                                GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white70,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          );
                                                        default:
                                                          return const SizedBox.shrink();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              barGroups: [
                                                BarChartGroupData(
                                                  x: 0,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: total.toDouble(),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.blue.shade700,
                                                          Colors.blue.shade900
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                      width: 32,
                                                    ),
                                                  ],
                                                ),
                                                BarChartGroupData(
                                                  x: 1,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: success.toDouble(),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.green.shade700,
                                                          Colors.green.shade900
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                      width: 32,
                                                    ),
                                                  ],
                                                ),
                                                BarChartGroupData(
                                                  x: 2,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: errors.toDouble(),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.red.shade700,
                                                          Colors.red.shade900
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                      width: 32,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 56, 30, 105),
        onPressed: _showCreateKeyDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        "API Keys",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget _analyticsBox(BuildContext context, String label, String value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100, minHeight: 80),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;

  const _RoundedInputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
