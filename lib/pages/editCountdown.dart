import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdownDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditCountdown extends StatefulWidget {
  Countdown countdown;

  EditCountdown({Key? key, required this.countdown}) : super(key: key);

  @override
  _EditCountdownState createState() => _EditCountdownState();
}

class _EditCountdownState extends State<EditCountdown> {
  final dbCountDown = CountdownDao.instance;
  late DateTime dateSelected;
  late DateTime dateSelectedComplete;

  TextEditingController customControllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    customControllerNote.text = widget.countdown.note;
    dateSelectedComplete = DateTime.parse(widget.countdown.completeDate);
    dateSelected = DateFormat('dd/MM').parse(widget.countdown.date);
  }

  getSelectedDateFormatted() {
    return DateFormat('dd/MM').format(dateSelected);
  }

  void _updateDayNote() async {
    Map<String, dynamic> row = {
      CountdownDao.columnId: widget.countdown.id,
      CountdownDao.columnDate: getSelectedDateFormatted().toString(),
      CountdownDao.columnCompleteDate: dateSelectedComplete.toString(),
      CountdownDao.columnNote: customControllerNote.text,
    };
    final update = await dbCountDown.update(row);
  }

  String checkProblems() {
    String errors = "";
    if (customControllerNote.text.isEmpty) {
      errors += "Note is empty\n";
    }
    return errors;
  }

  showAlertDialogErrors(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        "Ok",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      elevation: 3.0,
      title: Text(
        "Error",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        checkProblems(),
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

  chooseDate() async {
    DateTime? data = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (data != null) {
      setState(() {
        dateSelected = data;
        dateSelectedComplete = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Countdown"),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
                icon: Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (checkProblems().isEmpty) {
                    _updateDayNote();
                    Navigator.of(context).pop();
                  } else {
                    showAlertDialogErrors(context);
                  }
                },
              ),
            ),
          ],
        ),
        body: ListView(children: [
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Choose Date".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            onTap: () {
              chooseDate();
            },
            leading: Icon(Icons.calendar_today_outlined),
            title: Text(getSelectedDateFormatted().toString()),
          ),
          ListTile(
            leading: SizedBox(
              height: 0.1,
            ),
            title: Text("Note".toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor)),
          ),
          ListTile(
            leading: Icon(Icons.notes_outlined),
            title: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerNote,
              decoration: InputDecoration(
                focusColor: Theme.of(context).accentColor,
                helperText: "* Required",
              ),
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ]));
  }
}
