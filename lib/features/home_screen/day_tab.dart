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
          duration: const Duration(milliseconds: 500),
          height: 40.0,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [
                        const Color.fromARGB(255, 34, 8, 100), // Dark blue
                        const Color.fromARGB(255, 67, 39, 107), // Dark purple
                      ]
                    : [Colors.transparent, Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(5.0),
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                  fontSize: isSelected ? 18.0 : 12.0, color: Colors.white),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: isSelected ? 10.0 : 0.0,
        )
      ],
    );
  }
}
