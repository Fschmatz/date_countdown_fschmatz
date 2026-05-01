import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:date_countdown_fschmatz/classes/countdown.dart';
import 'package:date_countdown_fschmatz/util/app_details.dart';
import 'package:date_countdown_fschmatz/widgets/countdown_card.dart';
import 'package:date_countdown_fschmatz/widgets/store_countdown_dialog.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../redux/actions.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> loadCountdowns() async {
    await store.dispatch(LoadCountdownsAction());
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
                  showDialog(
                    context: context,
                    builder: (context) => const StoreCountdownDialog(),
                  );
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
          child: StoreConnector<AppState, List<Countdown>>(converter: (store) {
            return selectCountdowns();
          }, builder: (context, countdowns) {
            return ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.66,
                    crossAxisCount: 2,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: countdowns.length,
                  itemBuilder: (context, index) {
                    Countdown countdown = countdowns[index];

                    return CountdownCard(
                      key: ValueKey(countdown.id),
                      countdown: countdown,
                    );
                  },
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          }),
        ));
  }
}
