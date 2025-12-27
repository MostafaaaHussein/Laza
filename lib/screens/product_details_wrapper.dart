import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/review_model.dart';
import '../services/firestore_service.dart';
import 'product_details_screen.dart';
import 'reviews_screen.dart';

/// A stateful wrapper for ProductDetailsScreen that handles size selection state
class ProductDetailsWrapper extends StatefulWidget {
  final Product product;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final List<String> imageUrls;
  final double? rating;
  final bool isFavorite;
  final List<String> sizes;
  final VoidCallback? onToggleFavorite;
  final void Function(String size)? onAddToCart;
  final VoidCallback? onGoToCart;

  const ProductDetailsWrapper({
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
    this.onToggleFavorite,
    this.onAddToCart,
    this.onGoToCart,
  });

  @override
  State<ProductDetailsWrapper> createState() => _ProductDetailsWrapperState();
}

class _ProductDetailsWrapperState extends State<ProductDetailsWrapper> {
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    // Default to first size if available
    if (widget.sizes.isNotEmpty) {
      _selectedSize = widget.sizes.first;
    }
  }

  void _selectSize(String size) {
    setState(() {
      _selectedSize = size;
    });
  }

  void _handleAddToCart() {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    
    widget.onAddToCart?.call(_selectedSize!);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} (Size: $_selectedSize) added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.of(context).maybePop(); // Close details screen
            widget.onGoToCart?.call(); // Navigate to Cart tab
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestoreService.getReviews(widget.product.id.toString()),
      builder: (context, snapshot) {
        List<Widget> reviewWidgets = [];
        double? currentRating = widget.rating;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final reviews = snapshot.data!.docs
              .map((doc) => ReviewModel.fromFirestore(doc))
              .toList();

          // Display top 2 reviews in preview
          reviewWidgets = reviews.take(2).map((review) {
            return _buildReviewPreview(context, review);
          }).toList();

          // Calculate average rating from Firestore
          double total = 0;
          for (var r in reviews) {
            total += r.rating;
          }
          currentRating = total / reviews.length;
        }

        return ProductDetailsScreen(
          product: widget.product,
          title: widget.title,
          subtitle: widget.subtitle,
          description: widget.description,
          price: widget.price,
          imageUrls: widget.imageUrls,
          rating: currentRating,
          isFavorite: widget.isFavorite,
          sizes: widget.sizes,
          selectedSize: _selectedSize,
          onSelectSize: _selectSize,
          reviewItems: reviewWidgets,
          onToggleFavorite: widget.onToggleFavorite,
          onAddToCart: _handleAddToCart,
          onViewReviews: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewsScreen(
                  productId: widget.product.id,
                  productName: widget.title,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReviewPreview(BuildContext context, ReviewModel review) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.userName,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.orangeAccent,
                  size: 14,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          review.comment,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
