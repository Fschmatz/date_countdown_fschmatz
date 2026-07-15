import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:date_countdown_fschmatz/classes/countdown.dart';

import '../classes/app_parameter.dart';

class AppState {
  List<Countdown> countdowns;
  List<AppParameter> appParameters;

  AppState({
    required this.countdowns,
    required this.appParameters,
  });

  static AppState initialState() => AppState(
        countdowns: [],
        appParameters: [],
      );

  AppState copyWith({
    List<Countdown>? countdowns,
    List<AppParameter>? appParameters,
  }) {
    return AppState(
      countdowns: countdowns ?? this.countdowns,
      appParameters: appParameters ?? this.appParameters,
    );
  }
}

extension BuildContextExtension on BuildContext {
  AppState get state => getState<AppState>();

  AppState read() => getRead<AppState>();

  R select<R>(R Function(AppState state) selector) => getSelect<AppState, R>(selector);

  R? event<R>(Evt<R> Function(AppState state) selector) => getEvent<AppState, R>(selector);
}
