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
  bool _validNote = true;
  TextEditingController controllerNote = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerNote.text = widget.countdown.note;
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
      CountdownDao.columnNote: controllerNote.text,
    };
    final update = await dbCountDown.update(row);
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
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
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
          title: Text("Edit Countdown"),
          actions: [
            IconButton(
              icon: Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: () {
                if (validateTextFields()) {
                  _updateDayNote();
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
