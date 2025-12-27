import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../services/firestore_service.dart';
import '../utils/app_spacing.dart';
import 'add_review_screen.dart';

class ReviewsScreen extends StatelessWidget {
  final int productId;
  final String productName;

  const ReviewsScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreService.getReviews(productId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reviews = snapshot.data?.docs
                  .map((doc) => ReviewModel.fromFirestore(doc))
                  .toList() ??
              [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${reviews.length} Reviews',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (reviews.isNotEmpty)
                          Row(
                            children: [
                              Text(
                                _calculateAverageRating(reviews).toStringAsFixed(1),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              _buildStarRating(_calculateAverageRating(reviews)),
                            ],
                          ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReviewScreen(
                              productId: productId,
                              productName: productName,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Add Review'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: reviews.isEmpty
                    ? const Center(child: Text('No reviews yet. Be the first!'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        itemCount: reviews.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _buildReviewItem(context, reviews[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;
    double total = 0;
    for (var review in reviews) {
      total += review.rating;
    }
    return total / reviews.length;
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star_rounded
              : (index < rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
          color: Colors.orangeAccent,
          size: 16,
        );
      }),
    );
  }

  Widget _buildReviewItem(BuildContext context, ReviewModel review) {
    final theme = Theme.of(context);
    final dateStr = "${review.createdAt.day} ${_getMonthName(review.createdAt.month)}, ${review.createdAt.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Text(
                    review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                    style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: review.rating.toStringAsFixed(1),
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' rating',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                _buildStarRating(review.rating),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          review.comment,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
