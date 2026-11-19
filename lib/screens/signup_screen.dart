import 'package:material_ui/material_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/animated_action_button.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'Student';

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _collegeController.dispose();
    _departmentController.dispose();
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

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.secondary),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
    );
  }

  Future<void> _signup() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final newUser = credential.user;

      if (newUser == null) {
        throw Exception('Account creation failed.');
      }

      await newUser.updateDisplayName(_nameController.text.trim());

      await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set(
        {
          'uid': newUser.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'college': _collegeController.text.trim(),
          'department': _departmentController.text.trim(),
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        },
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
        case 'email-already-in-use':
          message = 'This email is already registered. Please login.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'weak-password':
          message = 'Please choose a stronger password.';
          break;
        case 'operation-not-allowed':
          message = 'Enable Email/Password sign-in in Firebase.';
          break;
        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;
        default:
          message = e.message ?? 'Signup failed. Please try again.';
      }

      _showMessage(message);
    } on FirebaseException catch (e) {
      _showMessage(
        'Account created, but profile could not be saved. '
        'Check Firestore rules. Error: ${e.code}',
      );
    } catch (e) {
      _showMessage('Something went wrong: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: keyboardType == TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.words,
      decoration: _decoration(label: label, icon: icon),
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label.';
            }
            return null;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.hub_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Join CLIQUE',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Create your account and find your people.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                ),

                const SizedBox(height: 30),

                _buildTextField(
                  controller: _nameController,
                  label: 'Full name',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 17),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
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

                const SizedBox(height: 17),

                _buildTextField(
                  controller: _collegeController,
                  label: 'College name',
                  icon: Icons.account_balance_outlined,
                ),

                const SizedBox(height: 17),

                _buildTextField(
                  controller: _departmentController,
                  label: 'Department',
                  icon: Icons.school_outlined,
                ),

                const SizedBox(height: 17),

                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  decoration: _decoration(
                    label: 'Select your role',
                    icon: Icons.badge_outlined,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Student', child: Text('Student')),
                    DropdownMenuItem(value: 'Faculty', child: Text('Faculty')),
                  ],
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRole = value;
                            });
                          }
                        },
                ),

                const SizedBox(height: 17),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
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
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password.';
                    }

                    if (value.length < 6) {
                      return 'Password must contain at least 6 characters.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                AbsorbPointer(
                  absorbing: _isLoading,
                  child: Opacity(
                    opacity: _isLoading ? 0.7 : 1,
                    child: AnimatedActionButton(
                      text: _isLoading
                          ? 'CREATING ACCOUNT...'
                          : 'CREATE ACCOUNT',
                      icon: _isLoading ? null : Icons.arrow_forward_rounded,
                      color: AppColors.secondary,
                      glowColor: AppColors.secondary,
                      height: 56,
                      onPressed: _signup,
                    ),
                  ),
                ),

                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],

                const SizedBox(height: 22),

                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
