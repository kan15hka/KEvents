import 'package:flutter/material.dart';

class ButtonBox extends StatelessWidget {
  final String title;
  const ButtonBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 34, 8, 100), // Dark blue
                Color.fromARGB(255, 67, 39, 107), // Dark purple
              ]),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OutlinedBox extends StatelessWidget {
  final double boxWidth;
  final String title;
  const OutlinedBox({super.key, required this.boxWidth, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
