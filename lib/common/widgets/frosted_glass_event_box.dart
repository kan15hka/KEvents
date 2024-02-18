import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class FrostedGlassEventBox extends StatelessWidget {
  final double boxWidth;
  final int boxIndex;
  final double verticalBoxMargin;
  final int boxCount;

  final String boxTitle;
  const FrostedGlassEventBox(
      {super.key,
      required this.boxIndex,
      required this.verticalBoxMargin,
      required this.boxWidth,
      required this.boxCount,
      required this.boxTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.075, vertical: 7.5),
      child: GlassContainer(
        blur: 4,
        color: Colors.white.withOpacity(0.1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.blue.withOpacity(0.3),
          ],
        ),
        //--code to remove border
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Row(
            children: [
              //index

              Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(80, 34, 8, 100), // Dark blue
                          Color.fromARGB(80, 67, 39, 107), // Dark purple
                        ]),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 1.5)),
                child: Center(
                  child: Text(
                    (boxIndex + 1).toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10.0,
              ),

              //Event Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boxTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "$boxCount members",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Colors.white.withOpacity(0.5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
