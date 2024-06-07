import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';

class NewCountdown extends StatefulWidget {
  @override
  _NewCountdownState createState() => _NewCountdownState();
}

class _NewCountdownState extends State<NewCountdown> {
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

    dateSelected = DateTime.now();
    dateSelectedComplete = DateTime.now();
  }

  void _insert() async {
    Countdown toInsert = new Countdown();
    toInsert.note = controllerNote.text;
    toInsert.date = dateSelected;

    await countdownService.insert(toInsert);
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
        initialDate: dateSelected,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10),
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
          title: Text("New"),
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
                        Icons.today_outlined,
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FilledButton.icon(
                onPressed: () {
                  if (_validateBeforeStore()) {
                    _insert();
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
