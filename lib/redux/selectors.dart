import 'package:date_countdown_fschmatz/classes/countdown.dart';
import '../classes/app_parameter.dart';

import 'app_state.dart';

List<Countdown> selectCountdowns(AppState state) => state.countdowns;

List<AppParameter> selectAppParameters(AppState state) => state.appParameters;

String? selectParameterValueByKey(AppState state, String key) {
  try {
    return state.appParameters
        .firstWhere((element) => element.key == key)
        .value;
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(AppState state, String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(state, key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
