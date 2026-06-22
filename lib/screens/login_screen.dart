import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_usernameCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.9),    // Using theme
              AppColors.background,                   // Using theme
              AppColors.secondary.withOpacity(0.8),   // Using theme
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 72),
                  // Logo
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,    // Using theme
                          AppColors.secondary,   // Using theme
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.45), // Using theme
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.shopping_bag_outlined,
                        color: AppColors.surface, size: 40), // Using theme
                  ),
                  const SizedBox(height: 24),
                  Text('Axorvian',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.5,
                          color: AppColors.textDark)), // Using theme
                  const SizedBox(height: 6),
                  Text('YOUR WORLD OF STYLE',
                      style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 3.5,
                          color: AppColors.textLight.withOpacity(0.45))), // Using theme
                  const SizedBox(height: 56),

                  // Username
                  _GlassField(
                    controller: _usernameCtrl,
                    icon: Icons.person_outline_rounded,
                    hint: 'Username',
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 14),

                  // Password
                  _GlassField(
                    controller: _passwordCtrl,
                    icon: Icons.lock_outline_rounded,
                    hint: 'Password',
                    obscure: _obscure,
                    validator: (v) =>
                    v == null || v.length < 6 ? 'Min 6 characters' : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textLight.withOpacity(0.5), // Using theme
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _usernameCtrl.text = 'waleed';
                        _passwordCtrl.text = 'waleedpass';
                      },
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              color: AppColors.primary.withOpacity(0.8), // Using theme
                              fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign In button
                  _GradientButton(
                    label: 'Sign In',
                    icon: Icons.arrow_forward_rounded,
                    isLoading: auth.isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(
                              color: AppColors.textLight.withOpacity(0.6), // Using theme
                              fontSize: 14)),
                      TextButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const SignupScreen())),
                        child: Text('Sign Up',
                            style: TextStyle(
                                color: AppColors.primary.withOpacity(0.8), // Using theme
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Demo hint
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.06), // Using theme
                      borderRadius: BorderRadius.circular(16),
                      border:
                      Border.all(color: AppColors.divider.withOpacity(0.3)), // Using theme
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2), // Using theme
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.info_outline_rounded,
                              color: AppColors.primary.withOpacity(0.8), // Using theme
                              size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Demo Account',
                                  style: TextStyle(
                                      color: AppColors.textDark, // Using theme
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              const SizedBox(height: 2),
                              Text('Username: waleed  |  Password: waleedpass',
                                  style: TextStyle(
                                      color: AppColors.textLight.withOpacity(0.5), // Using theme
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _GlassField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.07), // Using theme
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)), // Using theme
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: AppColors.textDark, fontSize: 15), // Using theme
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.4)), // Using theme
          prefixIcon: Icon(icon, color: AppColors.textLight.withOpacity(0.5), size: 20), // Using theme
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorStyle: TextStyle(color: AppColors.error), // Using theme
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
    this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,    // Using theme
            AppColors.secondary,   // Using theme
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35), // Using theme
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              color: Colors.white, strokeWidth: 2.5),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                    color: AppColors.surface, // Using theme
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            if (icon != null) ...[
              const SizedBox(width: 10),
              Icon(icon, color: AppColors.surface, size: 20), // Using theme
            ],
          ],
        ),
      ),
    );
  }
}