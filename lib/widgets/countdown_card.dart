import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../classes/countdown.dart';
import 'countdown_bottom_sheet.dart';

class CountdownCard extends StatefulWidget {
  @override
  State<CountdownCard> createState() => _CountdownCardState();

  final Countdown countdown;

  CountdownCard({Key? key, required this.countdown}) : super(key: key);
}

class _CountdownCardState extends State<CountdownCard> {
  bool _isPast = false;
  bool _isToday = false;
  bool _isFuture = false;
  int _differenceInDays = 0;
  final int _daysComingSoon = 15;

  @override
  void initState() {
    super.initState();
  }

  void _calculateDateValues() {
    Jiffy today = Jiffy.now();
    Jiffy date = Jiffy.parseFromDateTime(widget.countdown.date!);

    _differenceInDays = Jiffy.parseFromDateTime(widget.countdown.date!).diff(today, unit: Unit.day).round().abs() + 1;
    _isPast = date.isBefore(today, unit: Unit.day);
    _isToday = date.isSame(today, unit: Unit.day);
    _isFuture = date.isAfter(today, unit: Unit.day);
  }

  String _generateCountdownText() {
    String comparisonResult = "";

    if (_isPast) {
      comparisonResult = "$_differenceInDays Days Ago";
    } else if (_isToday) {
      comparisonResult = "Today";
    } else if (_isFuture) {
      if (_differenceInDays == 1) {
        comparisonResult = "Tomorrow";
      } else {
        comparisonResult = "$_differenceInDays Days";
      }
    }

    return comparisonResult;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    Color backgroundColor = colorScheme.surfaceContainerHighest;

    if (_isPast) {
      backgroundColor = colorScheme.surfaceContainer;
    } else if (_isToday) {
      backgroundColor = colorScheme.tertiaryContainer;
    } else if (_differenceInDays <= _daysComingSoon) {
      backgroundColor = colorScheme.primaryContainer;
    }

    return backgroundColor;
  }

  Color _getTextColor(ColorScheme colorScheme) {
    Color textColor = colorScheme.onSurface;

    if (_isPast) {
      textColor = Theme.of(context).disabledColor;
    } else if (_isToday) {
      textColor = colorScheme.onTertiaryContainer;
    } else if (_differenceInDays <= _daysComingSoon) {
      textColor = colorScheme.onPrimaryContainer;
    }

    return textColor;
  }

  IconData _getIconData() {
    IconData iconData = Icons.hourglass_top_outlined;

    if (_isPast) {
      iconData = Icons.event_available_outlined;
    } else if (_isToday) {
      iconData = Icons.today;
    } else if (_differenceInDays <= _daysComingSoon) {
      iconData = Icons.priority_high_outlined;
    }

    return iconData;
  }

  void _showDetails() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => CountdownBottomSheet(countdown: widget.countdown),
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculateDateValues();
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = _getBackgroundColor(colorScheme);
    final textColor = _getTextColor(colorScheme);

    return Card(
      margin: const EdgeInsets.all(6),
      color: backgroundColor,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _showDetails,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _generateCountdownText(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _getIconData(),
                    color: textColor.withValues(alpha: 0.8),
                    size: 22,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.countdown.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.countdown.getDateFormatted(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
