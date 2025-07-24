import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:flutter/material.dart';

class ChangelogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color? themeColorText = Theme.of(context).colorScheme.primary;

    return Scaffold(
        appBar: AppBar(
          title: Text("Changelog"),
        ),
        body: ListView(children: <Widget>[
          ListTile(title: Text("Current Version", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorText))),
          ListTile(
            title: Text(
              AppDetails.changelogCurrent,
            ),
          ),
          ListTile(
            title: Text("Previous Versions", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorText)),
          ),
          ListTile(
            title: Text(
              AppDetails.changelogsOld,
            ),
          ),
        ]));
  }
}
