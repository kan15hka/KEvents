import 'package:flutter/material.dart';

class DayTab extends StatelessWidget {
  final String day;
  final bool isSelected;
  const DayTab({super.key, required this.isSelected, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: 40.0,
          width: 80.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [
                        Color.fromARGB(255, 34, 8, 100), // Dark blue
                        Color.fromARGB(255, 67, 39, 107), // Dark purple
                      ]
                    : [Colors.transparent, Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(5.0),
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)),
          child: Center(
            child: Text(
              day,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: isSelected ? 20.0 : 0.0,
        )
      ],
    );
  }
}
