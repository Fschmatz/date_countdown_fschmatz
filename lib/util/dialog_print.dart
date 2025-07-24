import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';

class DialogPrint extends StatefulWidget {
  @override
  State<DialogPrint> createState() => _DialogPrintState();

  DialogPrint({Key? key}) : super(key: key);
}

class _DialogPrintState extends State<DialogPrint> {
  bool loading = true;
  String formattedList = '';

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void getNotes() async {
    List<Countdown> _countdownList = await CountdownService().queryAllRowsDesc();

    formattedList += 'Countdowns - ' + _countdownList.length.toString() + ' \n\n';

    for (int i = 0; i < _countdownList.length; i++) {
      formattedList += _countdownList[i].note! + "\n";
      formattedList += _countdownList[i].getDateFormatted() + "\n";
      formattedList += "\n";
    }

    setState(() {
      loading = false;
    });
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
