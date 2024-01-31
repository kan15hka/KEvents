import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/frosted_glass.dart';
import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:kevents/models/csv_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamParticipant extends StatefulWidget {
  const TeamParticipant({super.key});

  @override
  State<TeamParticipant> createState() => _TeamParticipantState();
}

class _TeamParticipantState extends State<TeamParticipant> {
  int index = 1;
  bool isNextClicked = true;
  bool isFirstParticipant = true;
  @override
  void initState() {
    super.initState();
    index = 1;
  }

  void _clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('fileSelected', false);
    // prefs.setString('filePath', '');
    // prefs.setString('eventType', '');
    prefs.setInt('teamNo', 0);
  }

  @override
  void dispose() {
    super.dispose();
    index = 1;
    isFirstParticipant = true;
    isNextClicked = true;
    _clearPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        FrostedGlass(
          isBorderRequired: false,
          blurValue: 4.0,
          borderRadius: 0.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "PARTICIPANT $index",
                style: const TextStyle(
                    fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        (isNextClicked)
            ? SoloParticipant(
                eventName: "EVENT",
                isTeam: true,
                isFirstParticipant: isFirstParticipant,
                makeNextClickedFalse: (bool newVal) {
                  setState(() {
                    isNextClicked = newVal;
                  });
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Text(
                  "Participant $index added successfully or Exists already",
                  textAlign: TextAlign.center,
                ),
              ),
      ],
    );
  }

  void quitFunction() async {
    if (index >= 1) {
      await removeData(isTeamNo: true, listData: []);
    }
    // ignore: use_build_context_synchronously
    showBottomSnackBar("Add Team Participants Quitted", context);
    setState(() {
      index = 1;
      isFirstParticipant = true;
    });
  }

  void finishFunction() {
    showBottomSnackBar("Add Team Participants Finished", context);
    setState(() {
      index = 1;
      isFirstParticipant = true;
      isNextClicked = true;
    });
  }

  void nextFunction() {
    if (isNextClicked == true) {
      showBottomSnackBar("Participants not added!!!", context);
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
