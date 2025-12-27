import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../models/product.dart';
import '../widgets/primary_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final List<String> imageUrls;
  final double? rating;
  final bool isFavorite;
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String>? onSelectSize;
  final String? totalPrice;
  final List<Widget>? reviewItems;
  final VoidCallback? onBack;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;
  final VoidCallback? onViewReviews;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.imageUrls,
    this.rating,
    this.isFavorite = false,
    this.sizes = const [],
    this.selectedSize,
    this.onSelectSize,
    this.totalPrice,
    this.reviewItems,
    this.onBack,
    this.onToggleFavorite,
    this.onAddToCart,
    this.onBuyNow,
    this.onViewReviews,
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
        actions: [
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 320,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                          ),
                          child: imageUrls[index].isNotEmpty
                              ? Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.image_outlined,
                                    color: theme.colorScheme.outline,
                                  ),
                                )
                              : Icon(
                                  Icons.image_outlined,
                                  color: theme.colorScheme.outline,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          price,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (rating != null)
                    Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Text(rating!.toStringAsFixed(1)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (imageUrls.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final url = imageUrls[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          width: 80,
                          color: theme.colorScheme.surfaceVariant,
                          child: url.isNotEmpty
                              ? Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image_outlined,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Size',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Size Guide'),
                  ),
                ],
              ),
              if (sizes.isNotEmpty)
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: sizes
                      .map(
                        (size) => ChoiceChip(
                          label: Text(size),
                          selected: selectedSize == size,
                          onSelected: (_) => onSelectSize?.call(size),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewReviews,
                    child: const Text('View All'),
                  ),
                ],
              ),
              if (reviewItems != null && reviewItems!.isNotEmpty)
                Column(
                  children: reviewItems!
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: item,
                          ))
                      .toList(),
                ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        totalPrice ?? price,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.md),
                      child: PrimaryButton(
                        label: 'Add to Cart',
                        expanded: true,
                        onPressed: onAddToCart ?? () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

