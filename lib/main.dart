import 'package:async_redux/async_redux.dart';
import 'package:date_countdown_fschmatz/redux/actions.dart';
import 'package:date_countdown_fschmatz/redux/app_state.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

final Store<AppState> store = Store<AppState>(
  initialState: AppState.initialState(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await store.dispatch(LoadCountdownsAction());

  runApp(
    StoreProvider<AppState>(
      store: store,
      child: EasyDynamicThemeWidget(
        child: const AppTheme(),
      ),
    ),
  );
}
