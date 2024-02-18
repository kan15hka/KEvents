import 'package:flutter/material.dart';

import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:kevents/features/event_screen/participant/team.dart';

class AddParticipantPage extends StatefulWidget {
  final String eventName;
  final int count;
  final String code;

  const AddParticipantPage(
      {super.key,
      required this.eventName,
      required this.count,
      required this.code});

  @override
  State<AddParticipantPage> createState() => _AddParticipantPageState();
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  @override
  Widget build(BuildContext context) {
    return (widget.count > 1)
        ? TeamParticipant(
            eventName: widget.eventName,
            count: widget.count,
            code: widget.code,
          )
        : SoloParticipant(
            code: widget.code,
            eventName: widget.eventName,
            isFirstParticipant: false,
            isTeam: false,
            makeNextClickedFalse: (_) {},
          );
  }
}
