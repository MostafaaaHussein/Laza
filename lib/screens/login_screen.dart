import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool rememberMe;
  final bool isSubmitting;

  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback onNavigateToSignup;
  final VoidCallback onForgotPassword;

  const LoginScreen({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.isSubmitting,
    required this.onRememberMeChanged,
    required this.onLogin,
    required this.onNavigateToSignup,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome',
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Welcome',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Please enter your data to continue',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Esther Howard',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Email is required' : null,
                  suffixIcon: const Icon(Icons.check, color: Colors.green, size: 16),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.length < 6 ? 'Password too short' : null,
                  suffixIcon: Text(
                    'Strong',
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.green),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onForgotPassword,
                    child: Text(
                      'Forgot password?',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remember me',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Switch.adaptive(
                      value: rememberMe,
                      onChanged: onRememberMeChanged,
                      activeColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Text(
                    'By connecting your account confirm that you agree\nwith our Term and Condition',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: PrimaryButton(
                    label: 'Login',
                    isLoading: isSubmitting,
                    onPressed: onLogin,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        'Create account',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
