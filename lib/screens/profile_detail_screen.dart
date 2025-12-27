import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_spacing.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Account Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _InfoTile(
              label: 'Name',
              value: FutureBuilder<String?>(
                future: authService.getUserName(),
                builder: (context, snapshot) => Text(snapshot.data ?? '...'),
              ),
              icon: Icons.person_outline,
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoTile(
              label: 'Email',
              value: Text(user?.email ?? 'No email'),
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoTile(
              label: 'User ID',
              value: Text(user?.uid ?? 'No UID', style: const TextStyle(fontSize: 12)),
              icon: Icons.fingerprint,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final Widget value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              DefaultTextStyle(
                style: theme.textTheme.bodyLarge!,
                child: value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
