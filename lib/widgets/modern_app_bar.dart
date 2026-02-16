import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const ModernAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading:
          leading ??
          (showBackButton
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Symbols.arrow_back, size: 20),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                )
              : null),
      actions: actions,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
