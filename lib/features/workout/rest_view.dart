import 'package:flutter/material.dart';

class RestView extends StatelessWidget {
  final int seconds;
  final int totalSeconds;

  const RestView({
    super.key,
    required this.seconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalSeconds > 0
        ? (totalSeconds - seconds) / totalSeconds
        : 0.0;

    return Semantics(
      label: 'Rest period, $seconds seconds remaining',
      liveRegion: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Flexible(
            flex: 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240, maxHeight: 240),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: theme
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      '$seconds',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 80,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Keep breathing',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
