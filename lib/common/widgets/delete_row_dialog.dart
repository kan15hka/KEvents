import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/frosted_glass_box.dart';

void deleteRowDialog(
    {required BuildContext context,
    required String mkid,
    required Function() onTapYes}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
              const Row(
                children: [
                  Text(
                    'Delete Row',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text("Do you really want remove participant with mkid:$mkid?"),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                      onTap: onTapYes,
                      child: const OutlinedBox(boxWidth: 70.0, title: "Yes")),
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const OutlinedBox(boxWidth: 70.0, title: "No"),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
