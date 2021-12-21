import 'dart:async';
import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdownDao.dart';
import 'package:date_countdown_fschmatz/pages/newCountdown.dart';
import 'package:date_countdown_fschmatz/widgets/countdownCard.dart';
import 'package:flutter/material.dart';
import 'configs/settingsPage.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> countdownList = [];
  final dbCountDown = CountdownDao.instance;

  @override
  void initState() {
    super.initState();
    getAll();
  }

  Future<void> getAll() async {
    var resp = await dbCountDown.queryAllRowsDesc();
    setState(() {
      countdownList = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Countdown'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SettingsPage(),
                      fullscreenDialog: true,
                    ));
              }),
        ],
      ),
      body: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
        ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
            shrinkWrap: true,
            itemCount: countdownList.length,
            itemBuilder: (context, index) {
              return CountdownCard(
                  key: UniqueKey(),
                  countdown: Countdown(
                    countdownList[index]['id'],
                    countdownList[index]['date'],
                    countdownList[index]['note'],
                    countdownList[index]['completeDate'],
                  ),
                  refreshHome: getAll);
            }),
        const SizedBox(
          height: 100,
        )
      ]),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => NewCountdown(),
                fullscreenDialog: true,
              )).then((value) => getAll());
        },
        child: Icon(
          Icons.add,
          color: Colors.black87
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
