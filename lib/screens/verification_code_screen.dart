import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';

class VerificationCodeScreen extends StatelessWidget {
  final List<TextEditingController> codeControllers;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;
  final VoidCallback? onResend;
  final String title;
  final String subtitle;
  final String resendLabel;
  final bool isSubmitting;
  final Widget? illustration;

  const VerificationCodeScreen({
    super.key,
    required this.codeControllers,
    required this.onSubmit,
    this.onBack,
    this.onResend,
    this.title = 'Verification Code',
    this.subtitle = 'Enter the code we sent to your email',
    this.resendLabel = 'resend confirmation code.',
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
                title,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: codeControllers
                    .map(
                      (controller) => SizedBox(
                        width: 70,
                        height: 90,
                        child: TextField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '00:20 ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: onResend,
                      child: Text(
                        'resend confirmation code.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: PrimaryButton(
                  label: 'Confirm Code',
                  isLoading: isSubmitting,
                  onPressed: onSubmit,
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

