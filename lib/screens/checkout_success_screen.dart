import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onContinue;
  final String? orderId;

  const CheckoutSuccessScreen({
    super.key,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onContinue,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (orderId != null) ...[
                Text(
                  'Order #$orderId',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: buttonLabel,
                onPressed: onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

