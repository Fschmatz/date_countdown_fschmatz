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
    var resp = await dbCountDown.queryAllRows();
    setState(() {
      countdownList = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Date Countdown'),
          elevation: 0,
        ),
        body: ListView(physics: AlwaysScrollableScrollPhysics(), children: [
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 15,),
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
            height: 50,
          )
        ]),
        floatingActionButton: Container(
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0.0,
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
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                IconButton(
                    color: Theme.of(context)
                        .textTheme
                        .headline6!
                        .color!
                        .withOpacity(0.8),
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
              ])),
        ));
  }
}
