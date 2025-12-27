import 'package:flutter/material.dart';
import 'new_password_screen.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    // Simulated password reset
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your password has been reset successfully. Please login with your new password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NewPasswordScreen(
      formKey: _formKey,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      onBack: () => Navigator.of(context).pushNamedAndRemoveUntil(
        '/welcome',
        (route) => false,
      ),
    );
  }
}
