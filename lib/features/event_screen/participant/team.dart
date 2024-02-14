import 'package:flutter/material.dart';
import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/frosted_glass.dart';
import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamParticipant extends StatefulWidget {
  const TeamParticipant({
    super.key,
    required this.eventName,
    //required this.count,
  });
  final String eventName;
  //final int count;

  @override
  State<TeamParticipant> createState() => _TeamParticipantState();
}

class _TeamParticipantState extends State<TeamParticipant> {
  int index = 1;
  bool isNextClicked = true;
  bool isFirstParticipant = true;
  bool canQuit = false;
  //late int count;
  @override
  void initState() {
    super.initState();
    index = 1;
    // setState(() {
    //   count = widget.count;
    // });
  }

  int teamNo = 0;
  String kid = "";
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      teamNo = prefs.getInt("teamNo") ?? 0;
      print(teamNo);
      kid = prefs.getString("kid") ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    index = 1;
    isFirstParticipant = true;
    isNextClicked = true;
    canQuit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: quitFunction, child: const ButtonBox(title: "QUIT")),
            GestureDetector(
                onTap: finishFunction, child: const ButtonBox(title: "FINISH")),
            GestureDetector(
                onTap: nextFunction, child: const ButtonBox(title: "NEXT"))
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        //Participant box
        if (isNextClicked)
          FrostedGlass(
            isBorderRequired: false,
            blurValue: 4.0,
            borderRadius: 0.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Participant $index",
                  style: const TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          ),
        (isNextClicked) // && count-- != 0
            ? SoloParticipant(
                eventName: widget.eventName,
                isTeam: true,
                isFirstParticipant: isFirstParticipant,
                makeNextClickedFalse: (bool newVal) {
                  setState(() {
                    isNextClicked = newVal;
                    //canQuit = true;
                  });
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 50.0),
                  child: Column(
                    children: [
                      Text(
                        "$teamNo",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                      Text(
                        kid,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                      Text(
                        "Participant $index added successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void quitFunction() async {
    if (canQuit) {
      int result = await removeDataTeamNo(teamNo: teamNo);
      if (result == 1) {
        // ignore: use_build_context_synchronously
        showBottomSnackBar(
          context: context,
          title: "Team Quitted!",
          content:
              "The currently added team will not be created for the event ${capitalizeAllWord(widget.eventName)}",
          status: SnackBarStatus.success,
        );
      } else {
        // ignore: use_build_context_synchronously
        showBottomSnackBar(
          context: context,
          title: "Oh Snap!",
          content:
              "Removal of participant was unsuccessfull for the event ${capitalizeAllWord(widget.eventName)}",
          status: SnackBarStatus.failure,
        );
      }
      setState(() {
        index = 1;
        isFirstParticipant = true;
        isNextClicked = true;
        canQuit = false;
      });
    } else {
      showBottomSnackBar(
        context: context,
        title: "Cannot Quit!",
        content:
            "No participant data has been added for the event ${capitalizeAllWord(widget.eventName)}",
        status: SnackBarStatus.warning,
      );
    }
  }

  void finishFunction() {
    showBottomSnackBar(
      context: context,
      title: "Team Created!",
      content:
          "Team Participants are created successfully for the event ${capitalizeAllWord(widget.eventName)}",
      status: SnackBarStatus.success,
    );
    setState(() {
      index = 1;
      isFirstParticipant = true;
      canQuit = false;
      isNextClicked = true;
    });
  }

  void nextFunction() async {
    await _loadPreferences();

    if (isNextClicked == true) {
      showBottomSnackBar(
        context: context,
        title: "Add Participant!",
        content:
            "No participant data has been added for the event ${capitalizeAllWord(widget.eventName)}",
        status: SnackBarStatus.warning,
      );
      return;
    }
    setState(() {
      index++;
      if (index == 1) {
        isFirstParticipant = true;
      } else {
        isFirstParticipant = false;
      }
      isNextClicked = true;
    });
    print(index);
  }
}
