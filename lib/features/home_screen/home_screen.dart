import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/background_widget.dart';
import 'package:kevents/features/home_screen/days_tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 20, 57),
      // resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "K! App".toUpperCase(),
                    style: const TextStyle(
                        fontFamily: "MeteoricLight",
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 16,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const DaysTabBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
