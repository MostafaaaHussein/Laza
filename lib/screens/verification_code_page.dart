import 'package:flutter/material.dart';
import 'verification_code_screen.dart';
import 'new_password_page.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool _isSubmitting = false;

  void _handleSubmit() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit code')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Mock verification delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordPage(email: widget.email),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VerificationCodeScreen(
      codeControllers: _controllers,
      onSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      onBack: () => Navigator.of(context).pushNamedAndRemoveUntil(
        '/welcome',
        (route) => false,
      ),
      onResend: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code resent!')),
        );
      },
    );
  }
}
