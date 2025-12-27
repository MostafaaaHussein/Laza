import 'package:flutter/material.dart';
import '../utils/app_spacing.dart';
import '../utils/ui_models.dart';

class ProfileMenuTile extends StatelessWidget {
  final ProfileMenuItem item;

  const ProfileMenuTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: item.onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(item.icon),
      ),
      title: Text(item.label),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

