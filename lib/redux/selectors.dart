import 'package:date_countdown_fschmatz/classes/countdown.dart';
import '../classes/app_parameter.dart';

import '../main.dart';

List<Countdown> selectCountdowns() => store.state.countdowns;

List<AppParameter> selectAppParameters() => store.state.appParameters;

String? selectParameterValueByKey(String key) {
  try {
    return store.state.appParameters
        .firstWhere((element) => element.key == key)
        .value;
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
