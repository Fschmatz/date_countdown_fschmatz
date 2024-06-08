import 'dart:async';
import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/db/countdown_dao.dart';
import 'package:date_countdown_fschmatz/pages/new_countdown.dart';
import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:date_countdown_fschmatz/widgets/countdown_card.dart';
import 'package:flutter/material.dart';
import '../service/countdown_service.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CountdownService countdownService = CountdownService.instance;
  List<Countdown> _countdownList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    loadCountdowns();
  }

  Future<void> loadCountdowns() async {
    _countdownList = await countdownService.queryAllRowsOrderByDateAsc();

    setState(() {
      _loading = false;
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
                Icons.add_outlined,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => NewCountdown(),
                    )).then((value) => loadCountdowns());
              }),
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
        child: _loading
            ? SizedBox.shrink()
            : ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 150, crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _countdownList.length,
                    itemBuilder: (context, index) {
                      Countdown countdown = _countdownList[index];
                      return CountdownCard(key: UniqueKey(), countdown: countdown, refreshHome: loadCountdowns);
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
      ),
    );
  }
}
