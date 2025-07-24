import 'package:date_countdown_fschmatz/classes/countdown.dart';

class AppState {
  List<Countdown> countdowns = [];

  AppState({required this.countdowns});

  static AppState initialState() => AppState(
        countdowns: [],
      );

  AppState copyWith({
    List<Countdown>? countdowns,
  }) {
    return AppState(
      countdowns: countdowns ?? this.countdowns,
    );
  }
}
