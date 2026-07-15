import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';

class StoreCountdownDialog extends StatefulWidget {
  final Countdown? countdown;

  const StoreCountdownDialog({Key? key, this.countdown}) : super(key: key);

  @override
  State<StoreCountdownDialog> createState() => _StoreCountdownDialogState();
}

class _StoreCountdownDialogState extends State<StoreCountdownDialog> {
  late DateTime _dateSelected;
  bool _validNote = true;
  bool _validDate = true;
  final TextEditingController _controllerNote = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  bool get isEditing => widget.countdown != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _controllerNote.text = widget.countdown!.note!;
      _dateSelected = widget.countdown!.date!;
    } else {
      _dateSelected = DateTime.now();
    }
    _updateDateText();
  }

  void _updateDateText() {
    _controllerDate.text = Jiffy.parseFromDateTime(_dateSelected).format(pattern: 'dd/MM/yyyy');
  }

  Future<void> _store() async {
    if (isEditing) {
      Countdown toUpdate = widget.countdown!.copyWith(
        date: _dateSelected,
        note: _controllerNote.text,
      );
      await CountdownService().update(toUpdate);
    } else {
      Countdown toInsert = Countdown(
        note: _controllerNote.text,
        date: _dateSelected,
      );
      await CountdownService().insert(toInsert);
    }
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

  Future<void> chooseDate() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dateSelected,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (data != null) {
      setState(() {
        _dateSelected = data;
        _updateDateText();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? "Edit" : "New"),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 12,
            ),
            TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 150,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: _controllerNote,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Note",
                helperText: "* Required",
                errorText: _validNote ? null : "Note is empty",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              readOnly: true,
              controller: _controllerDate,
              onTap: chooseDate,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Date",
                helperText: "* Required",
                errorText: _validDate ? null : "Date is empty",
                suffixIcon: const Icon(Icons.today_outlined),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton.icon(
          onPressed: () {
            if (_validateBeforeStore()) {
              _store();
              Navigator.of(context).pop();
            } else {
              setState(() {});
            }
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
