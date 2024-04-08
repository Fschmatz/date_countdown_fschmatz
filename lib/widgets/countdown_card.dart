import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:date_countdown_fschmatz/pages/edit_countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountdownCard extends StatefulWidget {
  @override
  _CountdownCardState createState() => _CountdownCardState();

  Countdown countdown;
  Function() refreshHome;

  CountdownCard({Key? key, required this.countdown, required this.refreshHome})
      : super(key: key);
}

class _CountdownCardState extends State<CountdownCard> {

  Future<void> _delete() async {
    final dbCountDown = CountdownDao.instance;
    await dbCountDown.delete(widget.countdown.id!);
  }

  getDateCountdown() {
    DateTime now = DateTime.now();
    DateTime savedDate = DateTime.parse(widget.countdown.completeDate!);
    Duration timeLeft = savedDate.difference(now);

    if (now.day.compareTo(savedDate.day).isEven &&
        now.month.compareTo(savedDate.month).isEven) {
      return 'Today';
    } else if (((timeLeft.inDays) + 1) == 1) {
      return '1\nDay    ';
    } else if (timeLeft.inDays < 0) {
      return ((timeLeft.inDays).abs() == 1
          ? (timeLeft.inDays).abs().toString() + '\nDay     \nAgo'
          : (timeLeft.inDays).abs().toString() + '\nDays   \nAgo');
    } else {
      return ((timeLeft.inDays) + 1).toString() + '\nDays  ';
    }
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
      ),
      onPressed: () {
        _delete();
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
    String countdown = getDateCountdown();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          openBottomMenu();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: countdown.contains('Ago')
                    ? Text(countdown,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: theme.hintColor))
                    : Text(countdown,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: theme.colorScheme.primary)),
              ),
            ),
            Container(
                height: 80,
                child: VerticalDivider(
                  thickness: 1,
                )),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    leading: Icon(
                      Icons.notes_outlined,
                    ),
                    title: Text(
                      widget.countdown.note!,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    leading: Icon(
                      Icons.calendar_today_outlined,
                    ),
                    title: Text(
                      widget.countdown.date!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
