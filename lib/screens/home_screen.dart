import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products;
  final String Function(Product) titleBuilder;
  final String Function(Product) subtitleBuilder;
  final String Function(Product) priceBuilder;
  final String? Function(Product)? imageBuilder;
  final bool Function(Product)? favoriteBuilder;
  final ValueChanged<Product>? onProductTap;
  final ValueChanged<Product>? onFavoriteToggle;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final List<String>? categories;
  final String? selectedCategory;
  final ValueChanged<String>? onCategorySelected;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenFavorites;
  final VoidCallback? onOpenProfile;
  final void Function(String)? onMenuAction;
  final VoidCallback? onViewAllBrands;
  final VoidCallback? onViewAllNewArrival;
  final String greetingTitle;
  final String greetingSubtitle;
  final int navigationIndex;
  final ValueChanged<int>? onNavigationChanged;

  const HomeScreen({
    super.key,
    required this.products,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.priceBuilder,
    this.imageBuilder,
    this.favoriteBuilder,
    this.onProductTap,
    this.onFavoriteToggle,
    this.searchController,
    this.onSearchChanged,
    this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.onOpenCart,
    this.onOpenFavorites,
    this.onOpenProfile,
    this.onMenuAction,
    this.onViewAllBrands,
    this.onViewAllNewArrival,
    this.greetingTitle = 'Hello',
    this.greetingSubtitle = 'Welcome to Laza.',
    this.navigationIndex = 0,
    this.onNavigationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    onSelected: onMenuAction,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sort),
                    ),
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'theme',
                        child: Row(
                          children: [
                            Icon(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(Theme.of(context).brightness == Brightness.dark
                                ? 'Light Mode'
                                : 'Dark Mode'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 20),
                            const SizedBox(width: 12),
                            const Text('Account Info'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'orders',
                        child: Row(
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 20),
                            const SizedBox(width: 12),
                            const Text('Orders History'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'favorites',
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border, size: 20),
                            const SizedBox(width: 12),
                            const Text('Favorites'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20, color: Colors.red),
                            const SizedBox(width: 12),
                            const Text('Logout', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onOpenCart,
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                greetingTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                greetingSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (categories != null && categories!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose Brand',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: onViewAllBrands,
                      child: const Text('View All'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories!.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final category = categories![index];
                      final isSelected = selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => onCategorySelected?.call(category),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Arrival',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewAllNewArrival,
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          'No products available',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        itemCount: products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            title: titleBuilder(product),
                            subtitle: subtitleBuilder(product),
                            price: priceBuilder(product),
                            imageUrl: imageBuilder?.call(product),
                            isFavorite: favoriteBuilder?.call(product) ?? false,
                            onTap: onProductTap != null
                                ? () => onProductTap!(product)
                                : null,
                            onFavoriteToggle: onFavoriteToggle != null
                                ? () => onFavoriteToggle!(product)
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationIndex,
        onDestinationSelected: onNavigationChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

