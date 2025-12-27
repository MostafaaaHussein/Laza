import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Product> favorites;
  final String Function(Product) titleBuilder;
  final String Function(Product) subtitleBuilder;
  final String Function(Product) priceBuilder;
  final String? Function(Product)? imageBuilder;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onToggleFavorite;
  final VoidCallback? onBack;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.priceBuilder,
    this.imageBuilder,
    this.onProductTap,
    this.onToggleFavorite,
    this.onBack,
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
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on products to add them here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return ProductCard(
                    product: product,
                    title: titleBuilder(product),
                    subtitle: subtitleBuilder(product),
                    price: priceBuilder(product),
                    imageUrl: imageBuilder?.call(product),
                    isFavorite: true,
                    onTap: onProductTap != null ? () => onProductTap!(product) : null,
                    onFavoriteToggle: onToggleFavorite != null ? () => onToggleFavorite!(product) : null,
                  );
                },
              ),
      ),
    );
  }
}
