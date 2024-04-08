import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogPrint extends StatefulWidget {
  DialogPrint({Key? key}) : super(key: key);

  @override
  _DialogPrintState createState() => _DialogPrintState();
}

class _DialogPrintState extends State<DialogPrint> {
  final db = CountdownDao.instance;
  bool loading = true;
  String formattedList = '';

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void getNotes() async {
    List<Map<String, dynamic>> _listNotes = await db.queryAllRowsDesc();

    formattedList += 'Countdowns - ' + _listNotes.length.toString() + ' \n\n';
    for (int i = 0; i < _listNotes.length; i++) {
      if (_listNotes[i]['note'].toString().isNotEmpty) {
        formattedList += _listNotes[i]['note'] + "\n";
        formattedList += _listNotes[i]['date'] + "\n";
        formattedList += "---------------\n";
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
        actions: [
          TextButton(
            child: const Text(
              "Copy",
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedList));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        children: [
          loading
              ? const SizedBox.shrink()
              : SelectableText(
                  formattedList,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
