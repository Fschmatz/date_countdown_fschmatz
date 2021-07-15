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
    if (now.day.compareTo(savedDate.day).isEven) {
      return 'Today';
    } else {
      if (((timeleft.inDays) + 1) == 1) {
        return '1 Day';
      } else {
        return ((timeleft.inDays) + 1).toString() + ' Days';
      }
    }
  }

  showAlertDialogOkDelete(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Yes",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor),
      ),
      onPressed: () {
        _delete();
        widget.refreshHome();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Confirm", //
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "\nDelete ?",
        style: TextStyle(
          fontSize: 18,
        ),
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

  //BOTTOM MENU
  void openBottomMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.edit_outlined,
                        color: Theme.of(context).hintColor),
                    title: Text(
                      "Edit countdown",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => EditCountdown(
                              countdown: widget.countdown,
                            ),
                            fullscreenDialog: true,
                          )).then((value) => widget.refreshHome());
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_outline_outlined,
                        color: Theme.of(context).hintColor),
                    title: Text(
                      "Delete countdown",
                      style: TextStyle(fontSize: 16),
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

    return Card(
      margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          openBottomMenu();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Column(
            children: [
              ListTile(
                title: Text(countdown,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Theme.of(context)
                            .accentTextTheme
                            .headline1!
                            .color)),
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_today_outlined,
                ),
                title:
                    Text(widget.countdown.date, style: TextStyle(fontSize: 16)),
              ),
              ListTile(
                leading: Icon(
                  Icons.notes_outlined,
                ),
                title:
                    Text(widget.countdown.note, style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
