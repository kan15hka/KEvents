//Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
    runApp(KEventsApp());
  });
  // runApp(
  //   const KEventsApp(),
  // );
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
          dividerTheme: DividerThemeData(
            color: Colors.transparent,
            space: 0,
            thickness: 0,
            indent: 0,
            endIndent: 0,
          ),
          textTheme:
              TextTheme(bodyMedium: TextStyle(fontSize: 16.0, color: kWhite)),
          fontFamily: "SpaceMono"),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => NavigationWidget(event: ""),
      //   MKIDPage.routeName: (context) => const MKIDPage(),
      //   QRScanner.routeName: (context) => const QRScanner(),
      // },
      home: const HomeScreen(),
    );
  }
}
