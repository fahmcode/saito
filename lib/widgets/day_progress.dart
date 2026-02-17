import 'package:flutter/material.dart';

enum DayStatus { active, inactive, today }

class DayProgress {
  final DateTime date;
  final DayStatus status;
  final int? dayNumber;

  DayProgress({required this.date, required this.status, this.dayNumber});
}

class ProgressGrid extends StatefulWidget {
  final List<DayProgress> days;
  final Function(DayProgress) onDayTap;

  const ProgressGrid({super.key, required this.days, required this.onDayTap});

  @override
  State<ProgressGrid> createState() => _ProgressGridState();
}

class _ProgressGridState extends State<ProgressGrid> {
  late final ScrollController _scrollController;
  static const double _spacing = 8.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    if (!mounted || widget.days.isEmpty) return;

    final todayIndex = widget.days.indexWhere(
      (d) => d.status == DayStatus.today,
    );
    if (todayIndex == -1) return;

    final firstDay = widget.days.first.date;
    final startOffset = firstDay.weekday - 1;
    final totalIndex = todayIndex + startOffset;

    // Column index in a 7-row grid
    final columnIndex = totalIndex ~/ 7;

    if (_lastCellSize > 0) {
      final scrollOffset = columnIndex * (_lastCellSize + _spacing);
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  double _lastCellSize = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.days.isEmpty) return const SizedBox.shrink();
    final firstDay = widget.days.first.date;
    final startOffset = firstDay.weekday - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 50, child: _buildDayLabels(context)),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = (constraints.maxHeight - (6 * _spacing)) / 7;

              if (_lastCellSize != cellSize) {
                _lastCellSize = cellSize;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToToday(),
                );
              }

              return GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: _spacing,
                  crossAxisSpacing: _spacing,
                  childAspectRatio: 1,
                ),
                itemCount: widget.days.length + startOffset,
                itemBuilder: (context, index) {
                  if (index < startOffset) {
                    return const SizedBox.shrink();
                  }
                  final dayIndex = index - startOffset;
                  final day = widget.days[dayIndex];
                  return _buildDayCell(context, day);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayLabels(BuildContext context) {
    final theme = Theme.of(context);
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: daysOfWeek.map((day) {
        return Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Text(
                day,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(BuildContext context, DayProgress day) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isToday = day.status == DayStatus.today;

    return Semantics(
      label: 'Day ${day.dayNumber}, ${day.status.name}',
      button: true,
      child: InkWell(
        onTap: () => widget.onDayTap(day),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: _getColor(day.status, colorScheme),
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: colorScheme.primary, width: 2.5)
                : null,
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: day.dayNumber != null && day.dayNumber! <= 100
              ? Center(
                  child: Text(
                    '${day.dayNumber}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: day.status == DayStatus.active
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Color _getColor(DayStatus status, ColorScheme colorScheme) {
    switch (status) {
      case DayStatus.active:
        return colorScheme.primary;
      case DayStatus.today:
        return colorScheme.primaryContainer;
      case DayStatus.inactive:
        return colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
    }
  }
}
