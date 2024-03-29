import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

enum SnackBarStatus { success, failure, warning }

Color getStautsColor(SnackBarStatus status) {
  if (status == SnackBarStatus.success) {
    return Colors.green;
  } else if (status == SnackBarStatus.warning) {
    return Colors.amber;
  } else {
    return Colors.red;
  }
}

void showBottomSnackBar({
  required String title,
  required String content,
  required BuildContext context,
  SnackBarStatus status = SnackBarStatus.success,
}) {
  //Remove Snackbar
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  //Show snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 3),
        content: Align(
          alignment: Alignment.topCenter,
          child: GlassContainer(
            blur: 10,
            color: Colors.white.withOpacity(0.1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.blue.withOpacity(0.6),
              ],
            ),
            //--code to remove border
            border: Border.all(
                color: getStautsColor(status).withOpacity(0.25), width: 1),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                //color: getStautsColor(status).withOpacity(0.9),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.5),
                    decoration: BoxDecoration(
                        color: getStautsColor(status),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                    child: Center(
                      child: Text(
                        title.toUpperCase(),
                        style: const TextStyle(fontSize: 17.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      content,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
  );
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(

  //       // duration: Duration(seconds: 4),
  //       margin: const EdgeInsets.only(bottom: 20.0),
  //       elevation: 0.0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       padding: EdgeInsets.zero,
  //       content: Center(
  //           child: FrostedGlass(
  //         isBorderRequired: false,
  //         blurValue: 5.0,
  //         borderRadius: 0.0,
  //         child: Container(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  //           child: Center(
  //               child: Text(
  //             text,
  //             style: const TextStyle(fontSize: 17.0),
  //           )),
  //         ),
  //       ))),
  // );
}
