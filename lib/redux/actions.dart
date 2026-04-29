import '../classes/countdown.dart';
import '../classes/app_parameter.dart';
import '../service/countdown_service.dart';
import '../service/app_parameter_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadCountdownsAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<Countdown> countdowns = await CountdownService().queryAllRowsDesc();

    return state.copyWith(countdowns: countdowns);
  }
}

class LoadAppParametersAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<AppParameter> parameters = await AppParameterService().getAll();
    return state.copyWith(appParameters: parameters);
  }
}

class SaveAppParameterAction extends AppAction {
  final AppParameter appParameter;

  SaveAppParameterAction(this.appParameter);

  @override
  Future<AppState> reduce() async {
    await AppParameterService().saveParameter(appParameter);
    return state;
  }
}
