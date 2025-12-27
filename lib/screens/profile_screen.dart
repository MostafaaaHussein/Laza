import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../utils/ui_models.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final List<ProfileMenuItem> menuItems;
  final VoidCallback? onEditProfile;
  final VoidCallback? onLogout;
  final VoidCallback? onBack;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.menuItems,
    this.avatarUrl,
    this.onEditProfile,
    this.onLogout,
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: onEditProfile,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person_outline, size: 32)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return ProfileMenuTile(item: item);
                  },
                ),
              ),
              PrimaryButton(
                label: 'Logout',
                onPressed: onLogout ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

