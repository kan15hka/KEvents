import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/frosted_glass.dart';
import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamParticipant extends StatefulWidget {
  const TeamParticipant({
    super.key,
    required this.eventName,
    required this.count,
    required this.code,
  });
  final String eventName;
  final String code;
  final int count;

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
    isNextClicked = true;
    getTeamNo();
  }

  int teamNo = 0;
  String kid = "";

  void getTeamNo() async {
    final openedCsvData = await readDataFromCSV();

    String teamNoStr = (openedCsvData.isEmpty)
        ? "1"
        : (openedCsvData[openedCsvData.length - 1][0]
            .toString()
            .replaceFirst("Team - ", "0"));
    teamNo = int.tryParse(teamNoStr) ?? 0;
    teamNo += 1;
    setState(() {});
    print(teamNo);
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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
        if (isNextClicked)
          FrostedGlass(
              isBorderRequired: false,
              blurValue: 4.0,
              borderRadius: 0.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Participant $index".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              )),
        (isNextClicked)
            ? SoloParticipant(
                code: widget.code,
                eventName: widget.eventName,
                isTeam: true,
                isFirstParticipant: isFirstParticipant,
                makeNextClickedFalse: (bool newVal) {
                  _loadPreferences();
                  setState(() {
                    isNextClicked = newVal;
                    canQuit = true;
                    print(isNextClicked);
                  });
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GlassContainer(
                        child: Container(
                          width: 250.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60.0,
                              ),
                              Text(
                                "Team :  $teamNo",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75)),
                              ),
                              Text(
                                "KID :  $kid",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Participant $index added",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.75)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -125.0,
                        child: LottieBuilder.asset(
                          "assets/images/rocketastro.json",
                          height: 250.0,
                          width: 250.0,
                        ),
                      )
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


    if (index >= widget.count) {
      showBottomSnackBar(
        context: context,
        title: "Maximum Limit",
        content: "Only ${widget.count} participants can be added.",
        status: SnackBarStatus.warning,
      );
      return;
    }
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
