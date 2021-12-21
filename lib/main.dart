import 'package:date_countdown_fschmatz/app.dart';
import 'package:date_countdown_fschmatz/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
      builder:(context, ThemeNotifier notifier, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme ? dark : light,
          home: App(),
        );
      },
    ),
  )
  );
}

