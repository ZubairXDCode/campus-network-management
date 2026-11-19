import 'package:material_ui/material_ui.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // One-time staged intro (logo -> title -> tagline -> loader).
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..forward();

  // Looping controller for floating orbs and logo glow.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  // Drives the loading bar and triggers navigation when complete.
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  late final Animation<double> _logoScale = Tween<double>(begin: 0.5, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _intro,
          curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
        ),
      );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
  );
  late final Animation<double> _titleFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
  );
  late final Animation<double> _titleSpacing = Tween<double>(begin: 22, end: 8)
      .animate(
        CurvedAnimation(
          parent: _intro,
          curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
        ),
      );
  late final Animation<double> _taglineFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
  );
  late final Animation<double> _loaderFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();

    _progress.forward();
    _progress.addStatusListener((status) {
      if (status == AnimationStatus.completed) _goToLogin();
    });
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF172554), Color(0xFF1D4ED8)],
          ),
        ),
        child: Stack(
          children: [
            // Floating background orbs
            _orb(top: -100, right: -80, size: 260, drift: 14),
            _orb(bottom: -120, left: -100, size: 300, drift: -18),
            _orb(top: 160, left: -40, size: 90, drift: 22),
            _orb(bottom: 180, right: -20, size: 70, drift: -16),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with pulsing glow
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _loop,
                        builder: (context, child) => Container(
                          height: 125,
                          width: 125,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(
                                  alpha: 0.25 + 0.2 * _loop.value,
                                ),
                                blurRadius: 30 + 25 * _loop.value,
                                spreadRadius: 4 + 6 * _loop.value,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                        child: const Icon(
                          Icons.hub_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App name: letter spacing tightens as it fades in
                  FadeTransition(
                    opacity: _titleFade,
                    child: AnimatedBuilder(
                      animation: _titleSpacing,
                      builder: (context, _) => ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFBFDBFE)],
                        ).createShader(rect),
                        child: Text(
                          'CLIQUE',
                          style: TextStyle(
                            fontSize: 39,
                            fontWeight: FontWeight.w900,
                            letterSpacing: _titleSpacing.value,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      'Connect. Collaborate. Grow.',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1.2,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // Loading bar
                  FadeTransition(
                    opacity: _loaderFade,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 160,
                          child: AnimatedBuilder(
                            animation: _progress,
                            builder: (context, _) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progress.value,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.15,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Connecting communities...',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _loaderFade,
                child: Text(
                  'ONE PLATFORM. COUNTLESS CONNECTIONS.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Colors.white.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Soft circle that drifts up/down slowly.
  Widget _orb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double drift,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _loop,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, drift * _loop.value),
          child: child,
        ),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.035),
          ),
        ),
      ),
    );
  }
}
