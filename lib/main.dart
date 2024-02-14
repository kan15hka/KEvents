//Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kevents/common/constants.dart';

import 'package:kevents/features/home_screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const KEventsApp());
  });
}

class KEventsApp extends StatelessWidget {
  const KEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    kheight = MediaQuery.of(context).size.height;
    kwidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'K! Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          space: 0,
          thickness: 0,
          indent: 0,
          endIndent: 0,
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0, color: kWhite)),
        fontFamily: "Nasalization",
      ),
      home: const HomeScreen(),
    );
  }
}
