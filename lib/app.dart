import 'package:date_countdown_fschmatz/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();

  const App({Key? key}) : super(key: key);
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color topOverlayColor = theme.colorScheme.surface;
    final Brightness iconBrightness = theme.brightness == Brightness.light ? Brightness.dark : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: iconBrightness,
          statusBarColor: topOverlayColor,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarIconBrightness: iconBrightness,
        ),
        child: Home());
  }
}
