import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/pages/edit_countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import '../service/countdown_service.dart';

class CountdownCard extends StatefulWidget {
  @override
  _CountdownCardState createState() => _CountdownCardState();

  Countdown countdown;
  Function() refreshHome;

  CountdownCard({Key? key, required this.countdown, required this.refreshHome}) : super(key: key);
}

class _CountdownCardState extends State<CountdownCard> {
  CountdownService countdownService = CountdownService.instance;
  bool isPast = false;
  bool isToday = false;
  bool isFuture = false;
  int differenceInDays = 0;

  @override
  void initState() {
    super.initState();

    _calculateDateValues();
  }

  void _calculateDateValues() {
    Jiffy today = Jiffy.now();
    Jiffy date = Jiffy.parseFromDateTime(widget.countdown.date!);

    differenceInDays = Jiffy.parseFromDateTime(widget.countdown.date!).diff(today, unit: Unit.day).round().abs() + 1;
    isPast = date.isBefore(today, unit: Unit.day);
    isToday = date.isSame(today, unit: Unit.day);
    isFuture = date.isAfter(today, unit: Unit.day);
  }

  String _generateCountdownText() {
    String comparisonResult = "";
    if (isPast) {
      comparisonResult = differenceInDays.toString() + " Days Ago";
    } else if (isToday) {
      comparisonResult = "Today";
    } else if (isFuture) {
      if (differenceInDays == 1)
        comparisonResult = "Tomorrow";
      else
        comparisonResult = differenceInDays.toString() + " Days";
    }

    return comparisonResult;
  }

  Card _generateTopInfoCard(ThemeData theme) {
    TextStyle dateStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w700);
    Color backgroundColor = Colors.transparent;
    Color textColor = theme.colorScheme.onPrimaryContainer;
    Icon? icon;

    if (isPast) {
      backgroundColor = theme.colorScheme.surfaceVariant;
      textColor = theme.colorScheme.onSurfaceVariant;
      icon = Icon(
        Icons.event_available_outlined,
        color: textColor,
      );
    } else if (isToday) {
      backgroundColor = theme.colorScheme.tertiaryContainer;
      textColor = theme.colorScheme.onTertiaryContainer;
      icon = Icon(
        Icons.today,
        color: textColor,
      );
    } else if (differenceInDays <= 10) {
      backgroundColor = theme.colorScheme.primaryContainer;
      textColor = theme.colorScheme.onPrimaryContainer;
      icon = Icon(
        Icons.priority_high_outlined,
        color: textColor,
      );
    }

    return Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: backgroundColor,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          dense: true,
          title: Text(_generateCountdownText(), maxLines: 1,
              overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: textColor)),
          trailing: icon,
          subtitle: Text(widget.countdown.getDateFormatted(), style: dateStyle),
        ));
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
      ),
      onPressed: () async {
        await countdownService.delete(widget.countdown.id!);
        widget.refreshHome();
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
                            builder: (BuildContext context) => EditCountdown(
                              countdown: widget.countdown,
                            ),
                          )).then((value) => widget.refreshHome());
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
    final theme = Theme.of(context);
    Card topInfoCard = _generateTopInfoCard(theme);
    TextStyle noteStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          openBottomMenu();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topInfoCard,
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
