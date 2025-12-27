import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;
  final VoidCallback? onCheckout;
  final VoidCallback? onBack;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onUpdateQuantity,
    this.onCheckout,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate totals
    final double subtotal = cartItems.fold(0, (sum, item) => sum + item.totalPrice);
    final double shippingFee = 0; // For now free or fixed
    final double total = subtotal + shippingFee;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text('Cart (${cartItems.fold(0, (sum, item) => sum + item.quantity)} items)'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: item.product.images.isNotEmpty
                                      ? Image.network(
                                          item.product.images[0],
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: theme.colorScheme.surfaceContainerHighest,
                                            child: Icon(
                                              Icons.image_outlined,
                                              color: theme.colorScheme.outline,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              // Product details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Size: ${item.size}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity controls
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () => onRemove(item.key),
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: theme.colorScheme.error,
                                    ),
                                    iconSize: 20,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => onUpdateQuantity(
                                          item.key,
                                          item.quantity - 1,
                                        ),
                                        icon: const Icon(Icons.remove_circle_outline),
                                        iconSize: 20,
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: theme.textTheme.titleSmall,
                                      ),
                                      IconButton(
                                        onPressed: () => onUpdateQuantity(
                                          item.key,
                                          item.quantity + 1,
                                        ),
                                        icon: const Icon(Icons.add_circle_outline),
                                        iconSize: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Checkout section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: FilledButton(
                            onPressed: onCheckout,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

