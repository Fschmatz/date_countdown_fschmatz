import 'package:date_countdown_fschmatz/db/countdownDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewCountdown extends StatefulWidget {
  @override
  _NewCountdownState createState() => _NewCountdownState();
}

class _NewCountdownState extends State<NewCountdown> {
  final dbCountDown = CountdownDao.instance;
  late DateTime dateSelected;
  late DateTime dateSelectedComplete;

  TextEditingController customControllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateSelected = DateTime.now();
    dateSelectedComplete = DateTime.now();
  }

  getSelectedDateFormatted() {
    return DateFormat('dd/MM/yyyy').format(dateSelected);
  }

  void _saveNote() async {
    Map<String, dynamic> row = {
      CountdownDao.columnNote: customControllerNote.text,
      CountdownDao.columnDate: getSelectedDateFormatted().toString(),
      CountdownDao.columnCompleteDate: dateSelectedComplete.toString(),
    };
    final id = await dbCountDown.insert(row);
    print(dateSelectedComplete.toString());
    print('id = $id');
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
        initialDate: dateSelected,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10));

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
          title: Text("New Countdown"),
          actions: [
            IconButton(
              icon: Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: () {
                if (checkProblems().isEmpty) {
                  _saveNote();
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
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerNote,
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
