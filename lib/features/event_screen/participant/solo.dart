import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/custom_textfield.dart';
import 'package:kevents/common/widgets/scanned_code_card.dart';
import 'package:kevents/common/widgets/text.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SoloParticipant extends StatefulWidget {
  final bool isTeam;
  final bool isFirstParticipant;
  final String eventName;

  final Function(bool) makeNextClickedFalse;
  const SoloParticipant({
    super.key,
    required this.isTeam,
    required this.eventName,
    required this.isFirstParticipant,
    required this.makeNextClickedFalse,
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
  List<List<String>> data = [];

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

  Future<void> addParticipantData() async {
    writeSuccessfull = await writeListToCsv(data: data);
    setState(() {
      writeSuccessfull;
    });
  }

  void showSnackBarOnWrite(int value) {
    if (value == 1) {
      showBottomSnackBar('Data added successfully', context);
    } else if (value == -1) {
      showBottomSnackBar('Data Exists already', context);
    } else if (value == 0) {
      showBottomSnackBar('Error Processing data', context);
    } else {
      print("Other error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                              await addParticipantData();

                              //Fuction to show snackbar
                              showSnackBarOnWrite(writeSuccessfull!);
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
                          height: MediaQuery.of(context).size.width * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderColor: const Color.fromARGB(255, 4, 4, 48),
                              borderRadius: 10,
                              borderLength: 40,
                              borderWidth: 10,
                              cutOutSize:
                                  MediaQuery.of(context).size.width * 0.65,
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
          textDesc('Enter the MK!Id'),
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
                List<String> temp = [
                  mkidTextController.text.toString(),
                  "-",
                  "-",
                  "-",
                  "-",
                  "-",
                ];
                if (!data.contains(temp)) data.add(temp);

                await addParticipantData();

                //Fuction to show snackbar
                showSnackBarOnWrite(writeSuccessfull!);
                //if data exists already
                if (writeSuccessfull == -1 || writeSuccessfull == 0) {
                  return;
                }

                mkidTextController.clear();

                //make isnextclicked false
                widget.makeNextClickedFalse(false);
              },
              child: const ButtonBox(title: "ADD MK!ID")),
        ],
        const SizedBox(height: 50.0),
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
        final paid = qrText['paid'];
        final events = paid['events'];
        name = qrText['name'];
        kid = qrText['kid'];
        List<String> temp = [
          qrText['kid'].toString(),
          qrText['name'].toString(),
          qrText['email'].toString(),
          qrText['phone'].toString(),
          qrText['college'].toString(),
          qrText['cegian'].toString(),
        ];
        if (!data.contains(temp)) data.add(temp);
        setState(() {
          status = !(isPaid(event: widget.eventName, eventList: events));
        });
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
  }
}
