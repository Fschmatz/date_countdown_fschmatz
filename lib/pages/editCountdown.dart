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
    dateSelected = DateFormat('dd/MM/yyyy').parse(widget.countdown.date);
  }

  getSelectedDateFormatted() {
    return DateFormat('dd/MM/yyyy').format(dateSelected);
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
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Error",
      ),
      content: Text(
        checkProblems(),
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
          actions: [
            IconButton(
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
          ],
        ),
        body: ListView(children: [
          ListTile(
            title: Text("Note",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            title: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerNote,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.notes_outlined),
                focusColor: Theme.of(context).colorScheme.primary,
                helperText: "* Required",
              ),
            ),
          ),
          ListTile(
            title: Text("Choose Date",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            onTap: () {
              chooseDate();
            },
            leading: Icon(Icons.calendar_today_outlined),
            title: Text(getSelectedDateFormatted().toString()),
          ),
        ]));
  }
}
