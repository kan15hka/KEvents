import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/background_widget.dart';
import 'package:kevents/common/constants.dart';
import 'package:kevents/features/home_screen/days_tab_bar.dart';
import 'package:rive/rive.dart' as rive;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  //color: Colors.red,
                  child: const Center(
                    child: Text(
                      "K! Event Management",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 16,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.green,
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
