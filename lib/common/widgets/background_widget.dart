import 'package:flutter/material.dart';
import 'package:kevents/common/constants.dart';
import 'package:rive/rive.dart' as rive;

class BackgroundWidget extends StatelessWidget {
  Widget child;
  BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background gradient
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 4, 4, 48), // Dark purple
              Color.fromARGB(255, 39, 26, 56), // Dark blue
              Color.fromARGB(255, 4, 4, 48), // Dark purple
            ],
          )),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const rive.RiveAnimation.asset(
            "assets/RiveAssets/floating_in_space.riv",
            fit: BoxFit.cover,
          ),
        ),
        //rive animation
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const rive.RiveAnimation.asset(
            "assets/RiveAssets/particles.riv",
            fit: BoxFit.cover,
          ),
        ),

        //childwidget

        child
      ],
    );
  }
}
