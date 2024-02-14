import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/frosted_glass_box.dart';

void showGlassDialogBox({
  required String title,
  required String content,
  bool isNoRequired = false,
  double buttonWidth = 70.0,
  required String buttonTitle,
  required BuildContext context,
  required Function() onTapYes,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0.75,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        // title: Text('Alert'),
        content: FrostedGlassBox(
          boxHieght: 200.0,
          boxWidth: MediaQuery.of(context).size.width * 0.8,
          borderRadius: 10.0,
          isBorderRequired: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(content),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                      onTap: onTapYes,
                      child: OutlinedBox(
                          boxWidth: buttonWidth, title: buttonTitle)),
                  const SizedBox(
                    width: 20.0,
                  ),
                  if (isNoRequired) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: OutlinedBox(boxWidth: buttonWidth, title: "No"),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
