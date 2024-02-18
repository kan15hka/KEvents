import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/background_widget.dart';
import 'package:kevents/features/home_screen/days_tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Text(
                      "K! Events".toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "MeteoricLight",
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30.0,
                      ),
                    ),
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
