import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/custom_textfield.dart';
import 'package:kevents/common/widgets/delete_row_dialog.dart';
import 'package:kevents/common/widgets/scanned_code_card.dart';
import 'package:kevents/common/widgets/text.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SoloParticipant extends StatefulWidget {
  final bool isTeam;
  final bool isFirstParticipant;
  final String eventName;
  final String code;
  final Function(bool) makeNextClickedFalse;
  const SoloParticipant({
    super.key,
    required this.isTeam,
    required this.eventName,
    required this.isFirstParticipant,
    required this.makeNextClickedFalse,
    required this.code,
  });

  @override
  State<SoloParticipant> createState() => _SoloParticipantState();
}

class _SoloParticipantState extends State<SoloParticipant> {
  final formKey = GlobalKey<FormState>();

  String? path;
  bool isScanning = false;
  bool isScanQrClicked = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? scannedBarCode;
  bool status = false;

  //participant's name and kid
  String? name;
  String? kid;

  //participant's detail
  List<String> data = [];

  QRViewController? controller;
  final TextEditingController mkidTextController = TextEditingController();
  int? writeSuccessfull;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Future<void> addParticipantData(
      {required bool isFirstParticipant, required bool isTeam}) async {
    writeSuccessfull = await writeListToCsv(
        data: data, isFirstParticipant: isFirstParticipant, isTeam: isTeam);
    setState(() {
      writeSuccessfull;
    });
  }

  void showSnackBarOnWrite(int value, BuildContext context) {
    if (value == 1) {
      showBottomSnackBar(
        context: context,
        title: "Participant Added!",
        content:
            "Participant data is successfully added for the event ${capitalizeAllWord(widget.eventName)}",
      );
    } else if (value == -1) {
      showBottomSnackBar(
        context: context,
        title: "Already Exists!",
        content:
            "Participant has been added already for the event ${capitalizeAllWord(widget.eventName)}",
        status: SnackBarStatus.warning,
      );
    } else if (value == 0) {
      showBottomSnackBar(
        context: context,
        title: "Oh Snap!",
        content:
            "Error adding participant data for the event ${widget.eventName}",
        status: SnackBarStatus.failure,
      );
    } else {
      print("Other error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        textDesc('Scan the QR Code'),
        const SizedBox(
          height: 15.0,
        ),
        //Scan Qr Image
        (status)
            ? Column(
                children: [
                  ScannedCodeCard(
                    name: name!,
                    kid: kid!,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              await addParticipantData(
                                  isTeam: widget.isTeam,
                                  isFirstParticipant:
                                      widget.isFirstParticipant);

                              //Fuction to show snackbar
                              showSnackBarOnWrite(writeSuccessfull!, context);

                              //if data exists already
                              if (writeSuccessfull == -1 ||
                                  writeSuccessfull == 0) {
                                return;
                              }

                              //make isnextclicked false
                              widget.makeNextClickedFalse(false);
                              setState(() {
                                isScanning = false;
                                isScanQrClicked = false;
                                scannedBarCode = null;
                                status = false;
                              });
                            },
                            child: const ButtonBox(title: "ADD KID")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isScanning = false;
                                isScanQrClicked = false;
                                scannedBarCode = null;
                                status = false;
                              });
                            },
                            child: const ButtonBox(title: "QUIT SCAN")),
                      ],
                    ),
                  )
                ],
              )
            : (isScanQrClicked)
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderColor: const Color.fromARGB(255, 4, 4, 48),
                              borderRadius: 10,
                              borderLength: 40,
                              borderWidth: 10,
                              cutOutSize: 250,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            controller!.pauseCamera();

                            setState(() {
                              isScanning = false;
                              isScanQrClicked = false;
                              scannedBarCode = null;
                              status = false;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ButtonBox(title: "QUIT SCAN"),
                          )),
                    ],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(15.0), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(80),
                          // Image radius
                          child: Image.asset('assets/images/qr.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isScanQrClicked = true;
                              isScanning = true;
                            });
                          },
                          child: const ButtonBox(title: "SCAN QR")),
                    ],
                  ),
        if (!isScanning) ...[
          //OR TEXT
          orText(),
          textDesc('Enter the K!Id'),
          //Text Field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: CustomTextField(
              textController: mkidTextController,
              formKey: formKey,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          GestureDetector(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  List<String> temp = [
                    "TeamNumber",
                    mkidTextController.text.toString(),
                    "-",
                    "-",
                    "-",
                    "-",
                    "-",
                  ];
                  data.clear();
                  data.addAll(temp);
                  //if (!data.contains(temp)) data.add(temp);

                  await addParticipantData(
                      isTeam: widget.isTeam,
                      isFirstParticipant: widget.isFirstParticipant);

                  showSnackBarOnWrite(writeSuccessfull!, context);

                  //if data exists already
                  if (writeSuccessfull == -1 || writeSuccessfull == 0) {
                    return;
                  }

                  mkidTextController.clear();

                  //make isnextclicked false
                  widget.makeNextClickedFalse(false);
                }
              },
              child: const ButtonBox(title: "ADD K!ID")),
        ],
        const SizedBox(height: 100.0),
        if (widget.isTeam)
          const SizedBox(
            height: 50.0,
          )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      scannedBarCode = scanData;
      try {
        String token = scannedBarCode!.code!
            .substring(1, scannedBarCode!.code!.length - 1);
        Map<String, dynamic> qrText = await jwtDecryption(token);
        final paid = qrText['paid'] ?? {};
        final bool isEventPaid =
            isPaid(eventCode: widget.code, eventList: paid);
        if (!isEventPaid) {
          await controller.pauseCamera();

          setState(() {
            isScanning = false;
            isScanQrClicked = false;
            scannedBarCode = null;
            status = false;
          });
          showGlassDialogBox(
            title: "Not Paid!!",
            content:
                "Participant ${qrText['name']} has not paid for the ${capitalizeAllWord(widget.eventName)} event.",
            buttonTitle: "Okay",
            buttonWidth: 100.0,
            context: context,
            onTapYes: () {
              Navigator.of(context).pop();
            },
          );
        }

        ///work
        name = qrText['name'] ?? "";
        kid = qrText['kid'] ?? "";
        List<String> temp = [
          "TeamNumber",
          qrText['kid'].toString(),
          qrText['name'].toString(),
          qrText['email'].toString(),
          qrText['phone'].toString(),
          qrText['college'].toString(),
          qrText['cegian'].toString(),
        ];
        data.clear();
        data.addAll(temp);
        setState(() {
          status = isEventPaid;
        });
      } on JWTExpiredException {
        print('jwt expired');
      } on JWTException catch (ex) {
        //todo: display a snackbar
        print('Error : Decrypt -> ${ex.message}'); // ex: invalid signature
      } catch (e) {
        print(e);
      }
    });
    controller.pauseCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    // AnimatedSnackBar.removeAll();
  }
}
