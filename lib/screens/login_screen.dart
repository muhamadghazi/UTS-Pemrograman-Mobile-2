import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _showSuccess = false;
  bool _rememberMe = false;

  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //  fungsi submit
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPassword = prefs.getString('user_password');

    if (_emailController.text == savedEmail &&
        _passwordController.text == savedPassword) {
      setState(() => _showSuccess = true);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()), // ke HomeScreen
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau kata sandi salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // <== ini tadi kurang, sekarang sudah ditutup

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFFE0B2),
                  Color(0xFFFFCC80)
                ],
              ),
            ),
          ),

          // Floating emoji animation
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: const Text('🍜',
                          style:
                              TextStyle(fontSize: 40, color: Colors.black26)),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 30,
                    child: Transform.translate(
                      offset: Offset(0, -_floatAnim.value),
                      child: const Text('🧋',
                          style:
                              TextStyle(fontSize: 40, color: Colors.black26)),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 30,
                    child: Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: const Text('🍳',
                          style:
                              TextStyle(fontSize: 40, color: Colors.black26)),
                    ),
                  ),
                  Positioned(
                    bottom: 140,
                    right: 40,
                    child: Transform.translate(
                      offset: Offset(0, -_floatAnim.value),
                      child: const Text('🍗',
                          style:
                              TextStyle(fontSize: 40, color: Colors.black26)),
                    ),
                  ),
                ],
              );
            },
          ),

          // Success message
          if (_showSuccess)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.green.withOpacity(0.3), blurRadius: 10)
                  ],
                ),
                child: const Text(
                  '✓ Login berhasil! Selamat datang kembali 🍱',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          // Main form
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              children: [
                // Header
                Text(
                  'Masuk ke KantinKu',
                  style: TextStyle(
                    fontSize: isSmall ? 26 : 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Akses cepat untuk pesan makanan di kampusmu 🍔',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmall ? 13 : 15,
                    color: const Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 40),

                // Form box
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInput(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          hint: 'contoh@kantinku.com',
                          validator: (v) => v == null || v.trim().length < 5
                              ? 'Email wajib diisi'
                              : null,
                        ),
                        _buildInput(
                          label: 'Kata Sandi',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          hint: 'Masukkan kata sandi',
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) => v == null || v.length < 6
                              ? 'Kata sandi minimal 6 karakter'
                              : null,
                        ),
                        const SizedBox(height: 8),

                        // Remember me + forgot password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xFFFF9800),
                                  onChanged: (v) {
                                    setState(() => _rememberMe = v ?? false);
                                  },
                                ),
                                const Text('Ingat saya'),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Link reset password dikirim ke email Anda'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  color: Color(0xFFE64A19),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9800),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            shadowColor:
                                const Color(0xFFFF9800).withOpacity(0.3),
                            elevation: 6,
                          ),
                          child: const Text(
                            'MASUK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Register link
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: 'Belum punya akun? ',
                              style: TextStyle(color: Color(0xFF616161)),
                              children: [
                                TextSpan(
                                  text: 'Daftar Sekarang',
                                  style: TextStyle(
                                    color: Color(0xFFE64A19),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  // Widget untuk input field
  Widget _buildInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF424242))),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFFFF9800)),
              suffixIcon: suffix,
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFFF9800), width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}
