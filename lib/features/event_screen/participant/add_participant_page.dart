import 'package:flutter/material.dart';

import 'package:kevents/features/event_screen/participant/solo.dart';
import 'package:kevents/features/event_screen/participant/team.dart';

class AddParticipantPage extends StatefulWidget {
  final String eventType;
  const AddParticipantPage({
    super.key,
    required this.eventType,
  });

  @override
  State<AddParticipantPage> createState() => _AddParticipantPageState();
}

class _AddParticipantPageState extends State<AddParticipantPage> {
  @override
  Widget build(BuildContext context) {
    return (widget.eventType == 'team')
        ? TeamParticipant()
        : SoloParticipant(
            isFirstParticipant: false,
            isTeam: false,
            makeNextClickedFalse: (v) {},
          );
  }
}
