import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String title;
  final String subtitle;
  final String price;
  final String? imageUrl;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.title,
    required this.subtitle,
    required this.price,
    this.imageUrl,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic sizes based on available width
        final imageHeight = constraints.maxWidth * 0.85;
        final titleStyle = theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: constraints.maxWidth < 150 ? 12 : 14,
        );
        final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: constraints.maxWidth < 150 ? 10 : 12,
        );
        final priceStyle = theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: constraints.maxWidth < 150 ? 12 : 14,
        );

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth < 150 ? AppSpacing.xs : AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image with favorite button
                  Stack(
                    children: [
                      SizedBox(
                        height: imageHeight,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: theme.colorScheme.outline,
                                        size: 32,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: theme.colorScheme.outline,
                                      size: 32,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Material(
                          color: theme.colorScheme.surface.withOpacity(0.9),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: onFavoriteToggle,
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                size: constraints.maxWidth < 150 ? 18 : 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Product title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                  const SizedBox(height: 2),
                  // Product subtitle/brand
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: subtitleStyle,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Price
                  Text(
                    price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: priceStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
