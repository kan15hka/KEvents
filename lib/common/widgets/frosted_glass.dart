import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  final Widget child;
  final double blurValue;
  final double borderRadius;
  final bool isBorderRequired;
  const FrostedGlass(
      {super.key,
      required this.borderRadius,
      required this.isBorderRequired,
      required this.blurValue,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child: Container(),
            ),
            //gradient effect and child
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                        color: isBorderRequired
                            ? Colors.white.withOpacity(0.25)
                            : Colors.transparent,
                        width: 1.0),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(150, 34, 8, 100), // Dark blue
                          Color.fromARGB(150, 67, 39, 107), // Dark purple
                        ])),
                //child
                child: child),
          ],
        ),
      ),
    );
  }
}
