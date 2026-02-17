import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfileAvatarButton extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;
  final double radius;

  const ProfileAvatarButton({
    super.key,
    this.imageUrl,
    required this.onTap,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Semantics(
            label: 'Open profile and settings',
            button: true,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: colorScheme.surfaceContainerHighest,
                backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
                onBackgroundImageError: hasImage
                    ? (exception, stackTrace) =>
                          debugPrint('Avatar error: $exception')
                    : null,
                // B1: If hasImage is true, child must be null so the image isn't obscured
                child: hasImage ? null : _buildFallback(colorScheme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildFallback(ColorScheme colorScheme) {
    return Icon(
      Symbols.account_circle,
      size: radius * 1.2,
      color: colorScheme.onSurfaceVariant,
    );
  }
}
