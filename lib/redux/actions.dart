import '../classes/countdown.dart';
import '../service/countdown_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadCountdownsAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<Countdown> countdowns = await CountdownService().queryAllRowsDesc();

    return state.copyWith(countdowns: countdowns);
  }
}
