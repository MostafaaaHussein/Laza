import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/login_screen.dart';
import '../screens/home_wrapper.dart';
import 'signup_screen.dart';
import 'forgot_password_page.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool isSubmitting = false;

  Future<void> _handleLogin() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isSubmitting = true);

    try {
      final authService = AuthService();
      await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      // ✅ Login success → go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeWrapper()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final authService = AuthService();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authService.handleAuthError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      formKey: formKey,
      emailController: emailController,
      passwordController: passwordController,
      rememberMe: rememberMe,
      isSubmitting: isSubmitting,
      onRememberMeChanged: (value) {
        setState(() => rememberMe = value);
      },
      onLogin: _handleLogin,
      onNavigateToSignup: () async {
        final email = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignupScreen()),
        );
        if (email != null && email is String && context.mounted) {
          emailController.text = email;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created. Please login.')),
          );
        }
      },
      onForgotPassword: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
        );
      },
    );
  }
}
