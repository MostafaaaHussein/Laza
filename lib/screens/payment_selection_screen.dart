import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../models/cart_item.dart';
import 'card_details_screen.dart';
import 'order_confirmation_screen.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const PaymentSelectionScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String _selectedMethod = 'Visa'; // Default

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _buildPaymentOption(
                    context,
                    title: 'Credit / Debit Card (Visa)',
                    icon: Icons.credit_card,
                    value: 'Visa',
                    subtitle: 'Pay securely with your card',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildPaymentOption(
                    context,
                    title: 'Cash on Delivery',
                    icon: Icons.money,
                    value: 'Cash',
                    subtitle: 'Pay when you receive the order',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withOpacity(0.2) : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    dynamic result;
    if (_selectedMethod == 'Visa') {
      // Navigate to Card Details
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardDetailsScreen(
            totalAmount: widget.totalAmount,
            cartItems: widget.cartItems,
          ),
        ),
      );
    } else {
      // Cash - Go directly to confirmation
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            totalAmount: widget.totalAmount,
            paymentMethod: 'Cash on Delivery',
            cartItems: widget.cartItems,
          ),
        ),
      );
    }

    if (result == true && mounted) {
      // Pass success back to previous screen
      Navigator.pop(context, true);
    }
  }
}
