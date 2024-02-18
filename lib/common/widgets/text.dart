import 'package:flutter/material.dart';

Widget textDesc(String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
    child: Text(
      content,
      style: TextStyle(fontSize: 15.0, color: Colors.white.withOpacity(0.75)),
    ),
  );
}

Widget orText() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1.5,
          ),
        ),
        textDesc("OR"),
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1.5,
          ),
        ),
      ],
    ),
  );
}
