import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text_field.dart';

class AddReviewScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const AddReviewScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _commentController = TextEditingController();
  final _nameController = TextEditingController();
  double _rating = 4.0;
  bool _isLoading = false;
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _authService.getUserName();
    if (name != null) {
      setState(() {
        _nameController.text = name;
      });
    }
  }

  Future<void> _submitReview() async {
    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to submit a review')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your experience')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reviewData = {
        'userId': user.uid,
        'userName': _nameController.text.trim().isEmpty ? 'Anonymous' : _nameController.text.trim(),
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'createdAt': DateTime.now(), // Firestore service converts this to server timestamp
      };

      await _firestoreService.addReview(widget.productId.toString(), reviewData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _nameController,
                        label: 'Name',
                        hint: 'Type your name',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'How was your experience?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _commentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Describe your experience...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Star',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _rating.toStringAsFixed(1),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _rating,
                        min: 0,
                        max: 5,
                        divisions: 50,
                        label: _rating.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => _rating = value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('0.0', style: TextStyle(fontSize: 12)),
                          Text('5.0', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                label: 'Submit Review',
                isLoading: _isLoading,
                onPressed: _submitReview,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
