import 'dart:async';
import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:date_countdown_fschmatz/pages/new_countdown.dart';
import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:date_countdown_fschmatz/widgets/countdown_card.dart';
import 'package:flutter/material.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Countdown> countdownList = [];
  final dbCountDown = CountdownDao.instance;

  @override
  void initState() {
    super.initState();

    loadCountdowns();
  }

  Future<void> loadCountdowns() async {
    var resp = await dbCountDown.queryAllRowsDesc();
    List<Countdown> response = [];

    if (resp.isNotEmpty) {
      response = resp.map((map) => Countdown.fromMap(map)).toList()
        ..sort((a, b) => DateTime.parse(a.completeDate!).compareTo(DateTime.parse(b.completeDate!)));
    }

    setState(() {
      countdownList = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppDetails.appNameHomePage),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage(),
                    ));
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadCountdowns,
        color: Theme.of(context).colorScheme.primary,
        child: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
              shrinkWrap: true,
              itemCount: countdownList.length,
              itemBuilder: (context, index) {
                return CountdownCard(key: UniqueKey(), countdown: countdownList[index], refreshHome: loadCountdowns);
              }),
          const SizedBox(
            height: 100,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NewCountdown(),
              )).then((value) => loadCountdowns());
        },
        child: Icon(Icons.add_outlined),
      ),
    );
  }
}
