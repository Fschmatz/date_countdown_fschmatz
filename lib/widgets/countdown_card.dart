import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/pages/store_countdown.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../service/countdown_service.dart';

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
  int _daysComingSoon = 15;

  @override
  void initState() {
    super.initState();

    _calculateDateValues();
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
      comparisonResult = _differenceInDays.toString() + " Days Ago";
    } else if (_isToday) {
      comparisonResult = "Today";
    } else if (_isFuture) {
      if (_differenceInDays == 1)
        comparisonResult = "Tomorrow";
      else
        comparisonResult = _differenceInDays.toString() + " Days";
    }

    return comparisonResult;
  }

  ListTile _generateTopInfoListTile(ColorScheme colorScheme) {
    Color textColor = _getTextColor(colorScheme);
    Icon? icon = _getIcon(textColor);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      dense: true,
      title: Text(_generateCountdownText(),
          maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: textColor)),
      trailing: icon,
      subtitle: Text(widget.countdown.getDateFormatted(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor)),
    );
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
    Color textColor = colorScheme.onPrimaryContainer;

    if (_isPast) {
      textColor = Theme.of(context).disabledColor;
    } else if (_isToday) {
      textColor = colorScheme.onTertiaryContainer;
    } else if (_differenceInDays <= _daysComingSoon) {
      textColor = colorScheme.onPrimaryContainer;
    }

    return textColor;
  }

  Icon _getIcon(Color color) {
    Icon? icon = Icon(
      Icons.hourglass_top_outlined,
      color: color,
    );

    if (_isPast) {
      icon = Icon(
        Icons.event_available_outlined,
        color: color,
      );
    } else if (_isToday) {
      icon = Icon(
        Icons.today,
        color: color,
      );
    } else if (_differenceInDays <= _daysComingSoon) {
      icon = Icon(
        Icons.priority_high_outlined,
        color: color,
      );
    }

    return icon;
  }

  double _getBorderRadius() {
    double radius = 12;

    if (_isPast) {
      radius = 8;
    } else if (_isToday) {
      radius = 25;
    } else if (_differenceInDays <= _daysComingSoon) {
      radius = 12;
    }

    return radius;
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
      ),
      onPressed: () async {
        await CountdownService().delete(widget.countdown.id!);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirm",
      ),
      content: Text(
        "Delete ?",
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openBottomMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Text(
                      "Created at:",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      widget.countdown.getCreatedAtFormatted(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.notes_outlined,
                    ),
                    title: Text(
                      widget.countdown.note!,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.today_outlined,
                    ),
                    title: Text(
                      widget.countdown.getDateFormatted(),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(
                      "Edit",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => StoreCountdown(
                              countdown: widget.countdown,
                            ),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined),
                    title: Text(
                      "Delete",
                    ),
                    onTap: () {
                      showAlertDialogOkDelete(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme = Theme.of(context).colorScheme;
    ListTile topInfoListTile = _generateTopInfoListTile(ColorScheme);
    TextStyle noteStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _getTextColor(ColorScheme));
    Color backgroundColor = _getBackgroundColor(Theme.of(context).colorScheme);
    double borderRadius = _getBorderRadius();

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          openBottomMenu();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topInfoListTile,
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Text(
                widget.countdown.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: noteStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
