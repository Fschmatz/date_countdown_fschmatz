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
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: IconButton(
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
            ),
          ],
        ),
        body: ListView(
            children: [
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
                  maxLength: 200,
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
            ]
        )
    );

  }
}
