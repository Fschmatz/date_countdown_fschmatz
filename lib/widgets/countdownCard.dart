import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdownDao.dart';
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
  openBottomMenuScrollable() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: widget.countdown.note.length > 400 ? 0.7 : 0.55,
          builder: (BuildContext context, myScrollController) {
            return Container(
              child: ListView(
                  controller: myScrollController,
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.calendar_today_outlined),
                              title: Text(
                                'opção 1',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.text_snippet_outlined),
                              title: Text(
                                'opção 2',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
      return ListTile(
      tileColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      leading: Icon(
        Icons.calendar_today_outlined,
        size: 22,
      ),
      title: Text(widget.countdown.note,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      onTap: openBottomMenuScrollable,
    );
  }
}
