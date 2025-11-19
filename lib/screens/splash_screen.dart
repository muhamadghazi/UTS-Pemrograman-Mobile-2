import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInScaleController;
  late Animation<double> _fadeInScaleAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _dotController;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();

    // Fade in scale animation
    _fadeInScaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeInScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _fadeInScaleController, curve: Curves.easeOut),
    );

    // Floating effect
    _floatController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -25).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse glow effect
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Dot pulse effect
    _dotController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _dotAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeInOut),
    );

    _fadeInScaleController.forward();

    // Navigasi ke login screen setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _fadeInScaleController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFF8F0),
              Color(0xFFFFE8D6),
              Color(0xFFFFD4B0),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background shapes
            Positioned(
              top: -screenHeight * 0.15,
              left: -screenWidth * 0.1,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * 0.5,
                        _floatAnimation.value * 0.5),
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.2,
              right: -screenWidth * 0.15,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(-_floatAnimation.value * 0.3,
                        _floatAnimation.value * 0.3),
                    child: Container(
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB74D).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: screenHeight * 0.5,
              right: -screenWidth * 0.1,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_floatAnimation.value * 0.2,
                        -_floatAnimation.value * 0.2),
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCC80).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Center glow
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Positioned(
                  top: screenHeight * 0.5 - 300 * _pulseAnimation.value,
                  left: screenWidth * 0.5 - 300 * _pulseAnimation.value,
                  child: Container(
                    width: 600 * _pulseAnimation.value,
                    height: 600 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),

            // Floating food icons
            _floatingIcon('🍱', screenHeight * 0.15, screenWidth * 0.15, 0),
            _floatingIcon('🧋', screenHeight * 0.2, screenWidth * 0.82, 2),
            _floatingIcon('🍜', screenHeight * 0.75, screenWidth * 0.12, 4),
            _floatingIcon('☕', screenHeight * 0.8, screenWidth * 0.85, 1.5),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _fadeInScaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fadeInScaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo container
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Logo glow
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 180 * _pulseAnimation.value,
                                  height: 180 * _pulseAnimation.value,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800)
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                            // Logo SVG (gunakan CustomPaint atau SvgPicture jika ada file SVG)
                            SvgPicture.string(
                              _logoSvg,
                              width: isSmallScreen ? 120 : 140,
                              height: isSmallScreen ? 120 : 140,
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // App title
                        Text(
                          'KantinKu',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 56 : 72,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
                              ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70)),
                            shadows: [
                              Shadow(
                                color: const Color(0xFFFF9800).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                              Shadow(
                                color:
                                    const Color(0xFFFF9800).withOpacity(0.15),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tagline
                        Text(
                          'Nikmati Hidangan Kampusmu Lebih Mudah',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8D6E63),
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Decorative dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _dotController,
                              builder: (context, child) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: 10 * _dotAnimation.value,
                                  height: 10 * _dotAnimation.value,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF9800),
                                        Color(0xFFF57C00)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF9800)
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingIcon(String emoji, double top, double left, double delay) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          );
        },
      ),
    );
  }

  // SVG Logo sebagai string (sederhanakan dari HTML)
  final String _logoSvg = '''
<svg viewBox="0 0 140 140" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bowlGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#FF9800;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#F57C00;stop-opacity:1" />
    </linearGradient>
  </defs>
  <path d="M35 60 Q35 55 40 55 L100 55 Q105 55 105 60 L105 75 Q105 95 70 95 Q35 95 35 75 Z" fill="url(#bowlGradient)" />
  <ellipse cx="70" cy="57" rx="32" ry="7" fill="#FFFFFF" opacity="0.6" />
  <ellipse cx="70" cy="60" rx="28" ry="6" fill="#FFE0B2" opacity="0.9" />
  <circle cx="62" cy="68" r="5" fill="#FFB74D" opacity="0.8" />
  <circle cx="75" cy="70" r="4" fill="#FFB74D" opacity="0.8" />
  <circle cx="68" cy="76" r="4.5" fill="#FFB74D" opacity="0.8" />
  <g transform="translate(25, 45) rotate(-25)">
    <rect x="0" y="0" width="3" height="28" rx="1.5" fill="url(#bowlGradient)" />
    <rect x="-2" y="0" width="1.5" height="10" rx="0.75" fill="url(#bowlGradient)" />
    <rect x="0.5" y="0" width="1.5" height="10" rx="0.75" fill="url(#bowlGradient)" />
    <rect x="3" y="0" width="1.5" height="10" rx="0.75" fill="url(#bowlGradient)" />
    <rect x="5.5" y="0" width="1.5" height="10" rx="0.75" fill="url(#bowlGradient)" />
  </g>
  <g transform="translate(110, 45) rotate(25)">
    <ellipse cx="2" cy="2" rx="4" ry="5" fill="url(#bowlGradient)" />
    <rect x="1" y="6" width="3" height="26" rx="1.5" fill="url(#bowlGradient)" />
  </g>
</svg>
''';
}
