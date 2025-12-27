import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class NewPasswordScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;
  final bool isSubmitting;
  final Widget? illustration;

  const NewPasswordScreen({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
    this.onBack,
    this.isSubmitting = false,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'New Password',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Illustration: Purple cloud with lock
              illustration ??
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.cloud,
                          size: 160,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        Icon(
                          Icons.lock,
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: AppSpacing.xl),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        if (value.length < 6) return 'Password too short';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value != passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Please write your new password.',
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
                  label: 'Reset Password',
                  isLoading: isSubmitting,
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      onSubmit();
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
