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
  bool _validNote = true;
  TextEditingController controllerNote = TextEditingController();

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
      CountdownDao.columnNote: controllerNote.text,
      CountdownDao.columnDate: getSelectedDateFormatted().toString(),
      CountdownDao.columnCompleteDate: dateSelectedComplete.toString(),
    };
    final id = await dbCountDown.insert(row);
  }

  bool validateTextFields() {
    if (controllerNote.text.isEmpty) {
      _validNote = false;
      return false;
    }
    return true;
  }

  chooseDate() async {
    DateTime? data = await showDatePicker(
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                onSurface: Theme.of(context).textTheme.headline6!.color!,
                background: Theme.of(context).primaryColor,
              ),
            ),
            child: child!,
          );
        });

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
                if (validateTextFields()) {
                  _saveNote();
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _validNote;
                  });
                }
              },
            ),
          ],
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 200,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: controllerNote,
              decoration: InputDecoration(
                  labelText: "Note",
                  helperText: "* Required",
                  errorText: _validNote ? null : "Note is empty"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 25, 10),
            child: Text(
              "Choose date",
              style:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            onTap: () {
              chooseDate();
            },
            leading: Icon(Icons.calendar_today_outlined),
            title: Text(getSelectedDateFormatted().toString()),
          ),
        ]));
  }
}
