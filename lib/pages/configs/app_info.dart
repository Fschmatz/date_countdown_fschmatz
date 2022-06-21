import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatelessWidget {
  _launchGithub() {
    launchUrl(
      Uri.parse(AppDetails.repositoryLink),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color? themeColorText = Theme.of(context).colorScheme.primary;

    return Scaffold(
        appBar: AppBar(
          title: Text("App Info"),
        ),
        body: ListView(children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.green,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(AppDetails.appName + " " + AppDetails.appVersion,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: themeColorText)),
          ),
          const SizedBox(height: 15),
          ListTile(
            title: Text("Dev",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeColorText)),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              "Application created using Flutter and the Dart language, used for testing and learning.",
            ),
          ),
          ListTile(
            title: Text("Source Code",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeColorText)),
          ),
          ListTile(
            onTap: () {
              _launchGithub();
            },
            leading: Icon(Icons.open_in_new_outlined),
            title: Text("View on GitHub",
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue)),
          ),
          ListTile(
            title: Text("Quote",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeColorText)),
          ),
          ListTile(
            leading: Icon(Icons.messenger_outline),
            title: Text(
              "By three methods we may learn wisdom: First, by reflection, which is noblest; Second, by imitation, which is easiest; and third by experience, which is the bitterest.",
            ),
          ),
        ]));
  }
}
