import 'dart:async';
import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdownDao.dart';
import 'package:date_countdown_fschmatz/pages/newCountdown.dart';
import 'package:date_countdown_fschmatz/widgets/countdownCard.dart';
import 'package:flutter/material.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> countdownList = [];
  final dbCountDown = CountdownDao.instance;

  @override
  void initState() {
    getAll();
    super.initState();
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Date Countdown'),
              pinned: false,
              floating: true,
              snap: true,
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
          ];
        },
        body: RefreshIndicator(
          onRefresh: getAll,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => NewCountdown(),
              )).then((value) => getAll());
        },
        child: Icon(
            Icons.add_outlined,
            color: Theme.of(context).colorScheme.onPrimary
        ),
      ),
    );
  }
}
