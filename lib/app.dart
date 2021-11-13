import 'package:date_countdown_fschmatz/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {

    final Color bottomOverlayColor = Theme.of(context).bottomAppBarColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: bottomOverlayColor,
        ),
        child: Home()
    );
  }
}
