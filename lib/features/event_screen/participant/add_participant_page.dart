import 'package:flutter/material.dart';

import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:kevents/features/event_screen/participant/team.dart';

class AddParticipantPage extends StatefulWidget {
  final String eventName;
  final String eventType;
  final int count;

  const AddParticipantPage(
      {super.key,
      required this.eventName,
      required this.eventType,
      required this.count});

  @override
  State<AddParticipantPage> createState() => _AddParticipantPageState();
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  @override
  Widget build(BuildContext context) {
    return (widget.eventType == 'team')
        ? TeamParticipant(
            eventName: widget.eventName,
            // count: widget.count,
          )
        : SoloParticipant(
            eventName: widget.eventName,
            isFirstParticipant: false,
            isTeam: false,
            makeNextClickedFalse: (v) {},
          );
  }
}
