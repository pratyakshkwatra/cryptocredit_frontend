import 'package:cryptocredit/api/exceptions.dart';
import 'package:cryptocredit/api/models/user.dart';
import 'package:cryptocredit/screens/auth/create_account.dart';
import 'package:cryptocredit/screens/home.dart';
import 'package:cryptocredit/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      User? user = await widget.authService.login(_email.text, _password.text);
      if (mounted) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(authService: widget.authService, user: user),
            ),
          );
        }
      }
    } on APIException catch (e) {
      _showError("${e.code}: ${e.message}");
    } catch (error) {
      _showError("Unexpected error. Please try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6A11CB);

    List<Color> backgroundGradient = [
      Color(0xFF2D1B4E),
      Color(0xFF1A102F),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.lock_outline, size: 64, color: primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your account',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _RoundedInputField(
                      controller: _email,
                      hintText: 'Email',
                      icon: Icons.person,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    _RoundedInputField(
                      controller: _password,
                      hintText: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    _RoundedButton(
                      label: 'Login',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _login,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?  ",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateAccountScreen(
                                  authService: widget.authService,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Create one',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF6A11CB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
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
        prefixIcon: Icon(icon, color: Colors.grey[400]),
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

class _RoundedButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _RoundedButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed == null ? color.withValues(alpha: 0.6) : color,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
