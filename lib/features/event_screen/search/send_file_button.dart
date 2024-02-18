import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class SendFileButton extends StatefulWidget {
  final String? filePath;
  const SendFileButton({super.key, required this.filePath});

  @override
  State<SendFileButton> createState() => _SendFileButtonState();
}

class _SendFileButtonState extends State<SendFileButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final shareResult = await Share.shareXFiles([XFile(widget.filePath!)]);

        if (shareResult.status == ShareResultStatus.success) {
          showBottomSnackBar(
            context: context,
            title: "Share succesful!",
            content: "The has been successfully shared",
            status: SnackBarStatus.success,
          );
        }
        if (shareResult.status == ShareResultStatus.dismissed) {
          showBottomSnackBar(
            context: context,
            title: "Share dismissed!",
            content: "File share has been dismissed by you",
            status: SnackBarStatus.warning,
          );
        }
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(100, 34, 8, 100), // Dark blue
                  Color.fromARGB(100, 67, 39, 107), // Dark purple
                ]),
            border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 1.5)),
        child: const Icon(
          FontAwesomeIcons.paperPlane,
          color: Color.fromARGB(150, 255, 255, 255),
        ),
      ),
    );
  }
}
