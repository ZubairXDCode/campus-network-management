import 'package:material_ui/material_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color navy = Color(0xFF090B18);
  static const Color blue = Color(0xFF2563EB);
  static const Color purple = Color(0xFF7C3AED);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _login() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = e.message ?? 'Login failed. Please try again.';
      }

      _showMessage(message);
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _forgotPassword() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showMessage('Enter your valid email address first.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _showMessage('Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Could not send reset email.');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: blue),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: blue, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                Container(
                  height: 76,
                  width: 76,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [blue, purple]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: blue.withAlpha(90),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Colors.white,
                    size: 43,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'CLIQUE',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'YOUR PEOPLE. YOUR CAMPUS.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(170),
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 38),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back, Legend!',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Sign in and reconnect with your community.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 28),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _decoration(
                            label: 'Email address',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email.';
                            }

                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value.trim())) {
                              return 'Enter a valid email address.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: _decoration(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }

                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isLoading ? null : _forgotPassword,
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'NEW TO CLIQUE?',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueGrey,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupScreen(),
                                      ),
                                    );
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: blue,
                              side: const BorderSide(color: blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'CREATE AN ACCOUNT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  'ONE PLATFORM. COUNTLESS CONNECTIONS.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
