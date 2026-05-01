import 'package:flutter/material.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';
import 'store_countdown_dialog.dart';

class CountdownBottomSheet extends StatelessWidget {
  final Countdown countdown;

  const CountdownBottomSheet({Key? key, required this.countdown}) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Delete ?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                await CountdownService().delete(countdown.id!);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Wrap(
          children: <Widget>[
            ListTile(
              dense: true,
              leading: const Text("Note:", style: TextStyle(fontSize: 16)),
              title: Text(countdown.note!, style: TextStyle(fontSize: 16)),
            ),
            ListTile(
              dense: true,
              leading: const Text("Date:", style: TextStyle(fontSize: 16)),
              title: Text(countdown.getDateFormatted(), style: TextStyle(fontSize: 16)),
            ),
            ListTile(
              dense: true,
              leading: const Text("Created at:", style: TextStyle(fontSize: 16)),
              title: Text(countdown.getCreatedAtFormatted(), style: TextStyle(fontSize: 16)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text("Edit"),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => StoreCountdownDialog(
                    countdown: countdown,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_outlined),
              title: const Text("Delete"),
              onTap: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
