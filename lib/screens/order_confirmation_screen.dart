import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../models/address.dart';
import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final double totalAmount;
  final String paymentMethod;
  final List<CartItem> cartItems;

  const OrderConfirmationScreen({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    required this.cartItems,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  late Future<Address?> _addressFuture;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  void _loadAddress() {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      _addressFuture = _firestoreService.getAddress(uid);
    } else {
      _addressFuture = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Address?>(
          future: _addressFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final address = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                           // Shipping Address Section
                           _buildSectionHeader(theme, 'Delivery Address'),
                           const SizedBox(height: 8),
                           Container(
                             width: double.infinity,
                             padding: const EdgeInsets.all(AppSpacing.md),
                             decoration: BoxDecoration(
                               color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                               borderRadius: BorderRadius.circular(AppRadius.md),
                             ),
                             child: address != null 
                             ? Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   address.fullName,
                                   style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                 ),
                                 const SizedBox(height: 4),
                                 Text('${address.building}, ${address.street}, ${address.area}'),
                                 Text('${address.city}'),
                                 const SizedBox(height: 4),
                                 Text(address.phone, style: theme.textTheme.bodySmall),
                               ],
                             )
                             : const Text('No address found'),
                           ),
                           const SizedBox(height: AppSpacing.xl),

                          _buildSectionHeader(theme, 'Payment Method'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  widget.paymentMethod.startsWith('Visa') ? Icons.credit_card : Icons.money,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    widget.paymentMethod,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Pop back to selection
                                     Navigator.of(context).pop(); 
                                     if (widget.paymentMethod.startsWith('Visa')) {
                                        Navigator.of(context).pop(); // Pop card details too
                                     }
                                  },
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          _buildSectionHeader(theme, 'Order Summary'),
                          const SizedBox(height: 8),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount'),
                              Text(
                                '\$${widget.totalAmount.toStringAsFixed(2)}',
                                 style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  PrimaryButton(
                    label: 'Confirm Order',
                    onPressed: () async {
                      try {
                        final uid = _authService.currentUser?.uid;
                        if (uid == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login to place an order')),
                          );
                          return;
                        }

                        // Convert cart items to order items format
                        final orderItems = widget.cartItems.map((item) => item.toOrderItem()).toList();

                        await _firestoreService.placeOrder(
                          uid: uid,
                          items: orderItems,
                          totalPrice: widget.totalAmount,
                          address: address?.toMap() ?? {'error': 'No address found'},
                        );

                        if (context.mounted) {
                          // Return true to signal success to the caller (HomeWrapper)
                          Navigator.of(context).pop(true);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error placing order: $e')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
