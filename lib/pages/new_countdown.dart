import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';

class NewCountdown extends StatefulWidget {
  @override
  State<NewCountdown> createState() => _NewCountdownState();
}

class _NewCountdownState extends State<NewCountdown> {
  late DateTime _dateSelected;
  late DateTime _dateSelectedComplete;
  bool _validNote = true;
  bool _validDate = true;
  TextEditingController _controllerNote = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dateSelected = DateTime.now();
    _dateSelectedComplete = DateTime.now();
  }

  void _insert() async {
    Countdown toInsert = new Countdown();
    toInsert.note = _controllerNote.text;
    toInsert.date = _dateSelected;

    await CountdownService().insert(toInsert);
  }

  bool _validateBeforeStore() {
    bool ok = true;
    if (_controllerNote.text.isEmpty) {
      ok = false;
      _validNote = false;
    }
    if (_controllerDate.text.isEmpty) {
      ok = false;
      _validDate = false;
    }

    return ok;
  }

  chooseDate() async {
    DateTime? data = await showDatePicker(
        context: context,
        initialDate: _dateSelected,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10),
        builder: (context, child) {
          return child!;
        });

    if (data != null) {
      setState(() {
        _dateSelected = data;
        _dateSelectedComplete = data;
        _controllerDate.text = DateFormat('dd/MM/yyyy').format(_dateSelected);
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
              controller: _controllerNote,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: "Note", helperText: "* Required", errorText: _validNote ? null : "Note is empty"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              readOnly: true,
              controller: _controllerDate,
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
