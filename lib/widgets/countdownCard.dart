import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdownDao.dart';
import 'package:date_countdown_fschmatz/pages/editCountdown.dart';
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
    final deleted = await dbCountDown.delete(widget.countdown.id);
  }

  getDateCountdown() {
    DateTime now = DateTime.now();
    DateTime savedDate = DateTime.parse(widget.countdown.completeDate);
    Duration timeleft = savedDate.difference(now);

    if (now.day.compareTo(savedDate.day).isEven &&
        now.month.compareTo(savedDate.month).isEven) {
      return 'Today';
    } else if (((timeleft.inDays) + 1) == 1) {
      return '1\nDay    ';
    } else if (timeleft.inDays < 0) {
      return ((timeleft.inDays).abs() == 1
          ? (timeleft.inDays).abs().toString() + '\nDay     \nAgo'
          : (timeleft.inDays).abs().toString() + '\nDays   \nAgo');
    } else {
      return ((timeleft.inDays) + 1).toString() + '\nDays  ';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text(
                        "Edit countdown",
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
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.delete_outline_outlined),
                      title: Text(
                        "Delete countdown",
                      ),
                      onTap: () {
                        showAlertDialogOkDelete(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String countdown = getDateCountdown();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                            color: Theme.of(context)
                                .textTheme
                                .headline1!
                                .color!
                                .withOpacity(0.6)))
                    : Text(countdown,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.secondary)),
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
                    title: Text(widget.countdown.note,
                        style: TextStyle(fontSize: 16)),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    leading: Icon(
                      Icons.calendar_today_outlined,
                    ),
                    title: Text(widget.countdown.date,
                        style: TextStyle(fontSize: 16)),
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
