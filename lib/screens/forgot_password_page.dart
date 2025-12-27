import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'forgot_password_screen.dart';
import 'verification_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      // 1. Generate a professional 4-digit OTP
      final String otp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

      // 2. Send REAL reset request & Log to Firestore
      await _authService.sendPasswordResetEmail(
        _emailController.text.trim(),
        otp: otp,
      );
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laza: A secure link and OTP have been sent to your email.'),
          backgroundColor: Colors.deepPurple,
        ),
      );
      
      // 3. Navigate to Verification Code screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCodePage(
            email: _emailController.text.trim(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authService.handleAuthError(e)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      formKey: _formKey,
      emailController: _emailController,
      onSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      onBack: () => Navigator.of(context).pushNamedAndRemoveUntil(
        '/welcome',
        (route) => false,
      ),
    );
  }
}
