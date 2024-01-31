import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/frosted_glass.dart';

void showBottomSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        // duration: Duration(seconds: 4),
        margin: const EdgeInsets.only(bottom: 20.0),
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: Center(
            child: FrostedGlass(
          isBorderRequired: false,
          blurValue: 5.0,
          borderRadius: 0.0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 17.0),
            )),
          ),
        ))),
  );
}
