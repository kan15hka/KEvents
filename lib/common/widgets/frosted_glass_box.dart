import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassBox extends StatelessWidget {
  final double boxWidth;
  final double boxHieght;
  final Widget child;
  final double borderRadius;
  final bool isBorderRequired;
  const FrostedGlassBox(
      {super.key,
      required this.boxHieght,
      required this.boxWidth,
      required this.borderRadius,
      required this.isBorderRequired,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: boxHieght,
        width: boxWidth,
        color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(),
            ),
            //gradient effect and child
            Container(
                height: boxHieght,
                width: boxWidth,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                        color: isBorderRequired
                            ? Colors.white.withOpacity(0.13)
                            : Colors.transparent,
                        width: 1.0),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.02)
                        ])),
                //child
                child: child),
          ],
        ),
      ),
    );
  }
}
