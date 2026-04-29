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
