import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailNimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showSuccessMessage = false;
  bool _isLoading = false;

  String? _selectedRole;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fullNameController.dispose();
    _emailNimController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email wajib diisi';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  // Fungsi daftar akun
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final existingEmail = prefs.getString('user_email');

      // Cek apakah email sudah terdaftar
      if (existingEmail == _emailNimController.text) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email sudah terdaftar. Gunakan email lain.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Simpan data pengguna baru
      await prefs.setString('user_fullname', _fullNameController.text);
      await prefs.setString('user_email', _emailNimController.text);
      await prefs.setString('user_password', _passwordController.text);
      await prefs.setString('user_role', _selectedRole ?? 'Pembeli');
      // Simpan role (default ke Pembeli kalau belum dipilih)

      setState(() {
        _isLoading = false;
        _showSuccessMessage = true;
      });

      // Setelah 2 detik, arahkan ke halaman login
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _showSuccessMessage = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  // Toggle password visibility
  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);

  void _toggleConfirmPasswordVisibility() =>
      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFE0B2),
              Color(0xFFFFCC80),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating emoji animasi
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0.05,
                      left: screenWidth * 0.05,
                      child: Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: const Text('🍜',
                            style:
                                TextStyle(fontSize: 38, color: Colors.black26)),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.15,
                      right: screenWidth * 0.05,
                      child: Transform.translate(
                        offset: Offset(0, -_floatAnimation.value),
                        child: const Text('🧋',
                            style:
                                TextStyle(fontSize: 38, color: Colors.black26)),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Pesan sukses
            if (_showSuccessMessage)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
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
                    '✓ Akun berhasil dibuat! Selamat datang di KantinKu',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

            // Form utama
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06, vertical: screenHeight * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Daftar dan nikmati kemudahan memesan makanan di kampusmu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF616161)),
                  ),
                  const SizedBox(height: 30),

                  // Kotak form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildFormGroup(
                            label: 'Nama Lengkap',
                            icon: Icons.person,
                            controller: _fullNameController,
                            placeholder: 'Masukkan nama lengkap',
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          // Pilih Peran (Pedagang / Pembeli)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFE0E0E0), width: 1.5),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Pilih Peran',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.people,
                                    color: Color(0xFF9E9E9E)),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Pembeli', child: Text('Pembeli')),
                                DropdownMenuItem(
                                    value: 'Pedagang', child: Text('Pedagang')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Pilih peran terlebih dahulu'
                                  : null,
                            ),
                          ),
                          _buildFormGroup(
                            label: 'Masukkan Email',
                            icon: Icons.email,
                            controller: _emailNimController,
                            placeholder: 'contoh@kantinku.com',
                            validator: _validateEmail,
                          ),
                          _buildFormGroup(
                            label: 'Kata Sandi',
                            icon: Icons.lock,
                            controller: _passwordController,
                            placeholder: 'Minimal 6 karakter',
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
                            validator: (v) => v != null && v.length < 6
                                ? 'Minimal 6 karakter'
                                : null,
                          ),
                          _buildFormGroup(
                            label: 'Konfirmasi Kata Sandi',
                            icon: Icons.lock_outline,
                            controller: _confirmPasswordController,
                            placeholder: 'Ulangi kata sandi',
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                            validator: (v) => v != _passwordController.text
                                ? 'Kata sandi tidak cocok'
                                : null,
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              minimumSize: const Size(double.infinity, 50.0),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Tombol ke Login
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Sudah punya akun? Masuk',
                              style: TextStyle(
                                color: Color(0xFFE64A19),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
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
      ),
    );
  }

  Widget _buildFormGroup({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF9E9E9E)),
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          filled: true,
          fillColor: const Color(0xFFFFF8E1),
        ),
      ),
    );
  }
}
