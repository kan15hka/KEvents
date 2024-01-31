import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlassEventBox extends StatelessWidget {
  final double boxWidth;
  final int boxIndex;
  final double verticalBoxMargin;
  final String boxType;

  final String boxTitle;
  const FrostedGlassEventBox(
      {super.key,
      required this.boxIndex,
      required this.verticalBoxMargin,
      required this.boxWidth,
      required this.boxType,
      required this.boxTitle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: verticalBoxMargin / 2,
            horizontal: (MediaQuery.of(context).size.width - boxWidth) / 2),
        width: boxWidth,
        color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: verticalBoxMargin / 2,
                    horizontal:
                        (MediaQuery.of(context).size.width - boxWidth) / 2),
                width: boxWidth,
              ),
            ),
            //gradient effect and child
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.13), width: 1.0),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05)
                      ])),
              //child
              child: Row(
                children: [
                  //index
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(80, 34, 8, 100), // Dark blue
                                  Color.fromARGB(
                                      80, 67, 39, 107), // Dark purple
                                ]),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.5)),
                        child: Center(
                          child: Text(
                            (boxIndex + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      //Event Type
                      Text(
                        boxType[0].toUpperCase() + boxType.substring(1),
                        style: const TextStyle(fontSize: 11.0),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),

                  //Event Title
                  Expanded(
                    child: Text(
                      boxTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
