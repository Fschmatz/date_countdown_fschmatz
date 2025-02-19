import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import '../../util/dialog_backup.dart';
import '../../util/dialog_print.dart';
import '../../util/dialog_select_theme.dart';
import 'app_info.dart';
import 'changelog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  final Function()? loadCountdowns;

  SettingsPage({Key? key, this.loadCountdowns}) : super(key: key);
}

class _SettingsPageState extends State<SettingsPage> {
  String getThemeStringFormatted() {
    String theme = EasyDynamicTheme.of(context).themeMode.toString().replaceAll('ThemeMode.', '');
    if (theme == 'system') {
      theme = 'system default';
    }
    return theme.replaceFirst(theme[0], theme[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    Color? themeColorText = Theme.of(context).colorScheme.primary;

    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: themeColorText,
              child: ListTile(
                title: Text(
                  AppDetails.appName + " " + AppDetails.appVersion,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.5, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            ListTile(
              title: Text("General", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorText)),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogSelectTheme();
                  }),
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text(
                "App theme",
              ),
              subtitle: Text(
                getThemeStringFormatted(),
              ),
            ),
            ListTile(
              title: Text("Backup", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorText)),
            ),
            ListTile(
                leading: const Icon(Icons.print_outlined),
                title: const Text("Print countdowns"),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DialogPrint(),
                      fullscreenDialog: true,
                    ))),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup(
                      isCreateBackup: true,
                      reloadHomeFunction: widget.loadCountdowns,
                    );
                  }),
              leading: const Icon(Icons.save_outlined),
              title: const Text(
                "Backup now",
              ),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup(
                      isCreateBackup: false,
                      reloadHomeFunction: widget.loadCountdowns,
                    );
                  }),
              leading: const Icon(Icons.settings_backup_restore_outlined),
              title: const Text(
                "Restore from backup",
              ),
            ),
            ListTile(
              title: Text("About", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorText)),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
              ),
              title: Text(
                "App info",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AppInfoPage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.article_outlined,
              ),
              title: Text(
                "Changelog",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChangelogPage(),
                    ));
              },
            ),
          ],
        ));
  }
}
