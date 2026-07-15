import 'package:flutter/material.dart';

import '../classes/countdown.dart';
import '../service/countdown_service.dart';
import 'modal_info_tile.dart';
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
        padding: const EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        countdown.note!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      ModalInfoTile(label: "Date:", value: countdown.getDateFormatted()),
                      ModalInfoTile(label: "Created at:", value: countdown.getCreatedAtFormatted()),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Column(
                  children: [
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
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_outline_outlined),
                      title: const Text("Delete"),
                      onTap: () => _showDeleteDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
