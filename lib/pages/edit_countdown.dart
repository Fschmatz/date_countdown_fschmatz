import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:date_countdown_fschmatz/service/countdown_service.dart';
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
  CountdownService countdownService = CountdownService.instance;
  late DateTime dateSelected;
  late DateTime dateSelectedComplete;
  bool _validNote = true;
  bool _validDate = true;
  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    controllerNote.text = widget.countdown.note!;
    dateSelectedComplete = widget.countdown.date!;
    dateSelected = widget.countdown.date!;
    controllerDate.text = DateFormat('dd/MM/yyyy').format(dateSelected);
  }

  Future<void> _update() async {
    Countdown toUpdate = widget.countdown;
    toUpdate.date = dateSelected;
    toUpdate.note = controllerNote.text;

    await countdownService.update(toUpdate);
  }

  bool _validateBeforeStore() {
    bool ok = true;
    if (controllerNote.text.isEmpty) {
      ok = false;
      _validNote = false;
    }
    if (controllerDate.text.isEmpty) {
      ok = false;
      _validDate = false;
    }

    return ok;
  }

  chooseDate() async {
    DateTime? data = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (context, child) {
          return child!;
        });

    if (data != null) {
      setState(() {
        dateSelected = data;
        dateSelectedComplete = data;
        controllerDate.text = DateFormat('dd/MM/yyyy').format(dateSelected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit"),
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
                  border: const OutlineInputBorder(), labelText: "Note", helperText: "* Required", errorText: _validNote ? null : "Note is empty"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              readOnly: true,
              controller: controllerDate,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Date",
                  helperText: "* Required",
                  errorText: _validDate ? null : "Date is empty",
                  suffixIcon: IconButton(
                      onPressed: () {
                        chooseDate();
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FilledButton.icon(
                onPressed: () {
                  if (_validateBeforeStore()) {
                    _update();
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _validNote;
                    });
                  }
                },
                icon: Icon(Icons.save_outlined),
                label: Text('Save')),
          ),
        ]));
  }
}
