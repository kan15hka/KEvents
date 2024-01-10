import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:kevents/common/widgets/button_box.dart';
import 'package:kevents/common/widgets/custom_textfield.dart';
import 'package:kevents/common/widgets/scanned_code_card.dart';
import 'package:kevents/common/widgets/text.dart';
import 'package:kevents/models/csv_data.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoloParticipant extends StatefulWidget {
  final bool isTeam;
  final bool isFirstParticipant;

  final Function(bool) makeNextClickedFalse;
  SoloParticipant(
      {super.key,
      required this.isTeam,
      required this.isFirstParticipant,
      required this.makeNextClickedFalse});

  @override
  State<SoloParticipant> createState() => _SoloParticipantState();
}

class _SoloParticipantState extends State<SoloParticipant> {
  @override
  final formKey = GlobalKey<FormState>();

  String? path;
  bool isScanning = false;
  bool isScanQrClicked = false;
  Map<String, dynamic> participantData = {};
  // String? _filePath; //Selected File Path
  bool isFileSelected = false; //File Selected or Not
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? scannedBarCode;
  QRViewController? controller;
  final TextEditingController mkidTextController = TextEditingController();
  String? filePath;
  int? writeSuccessfull;
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filePath = prefs.getString('filePath');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPreferences();
    });
  }

  Future<void> writeCsv(
      {required String filePath,
      required List<dynamic> data,
      required BuildContext context,
      required bool isTeam,
      required bool isFirstParticipant}) async {
    writeSuccessfull = await writeListtoCsv(
        isFirstParticipant: isFirstParticipant,
        isTeam: isTeam,
        filePath: filePath,
        data: data,
        context: context);
    setState(() {
      writeSuccessfull;
    });
  }

  void showSnackBarOnWrite(int value) {
    print("Result:" + value.toString());
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

  Widget build(BuildContext context) {
    return Column(
      children: [
        textDesc('Scan the QR Code'),
        const SizedBox(
          height: 15.0,
        ),
        //Scan Qr Image
        (scannedBarCode != null)
            ? Column(
                children: [
                  ScannedCodeCard(
                      name: participantData["name"],
                      mkid: participantData['mkid']),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              await _loadPreferences();
                              //Conver Mapto List<dynamic>
                              List<dynamic> data =
                                  participantData.values.toList();

                              //write to csv file
                              //local funcyion
                              await writeCsv(
                                  isFirstParticipant: widget.isFirstParticipant,
                                  isTeam: widget.isTeam,
                                  filePath: filePath!,
                                  data: data,
                                  context: context);
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
                                participantData.clear();
                              });
                            },
                            child: const ButtonBox(title: "ADD MKID")),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isScanning = false;
                                isScanQrClicked = false;
                                scannedBarCode = null;
                                participantData.clear();
                              });
                            },
                            child: ButtonBox(title: "QUIT SCAN")),
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
                              participantData.clear();
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
                if (formKey.currentState!.validate()) {
                  print(mkidTextController.text);
                  List<dynamic> mkidDataList = [
                    "0",
                    mkidTextController.text.toString(),
                    "null",
                    "null",
                    "null",
                    "null",
                    "null"
                  ];

                  //write to csv file
                  //local funcyion
                  await writeCsv(
                      isFirstParticipant: widget.isFirstParticipant,
                      isTeam: widget.isTeam,
                      filePath: filePath!,
                      data: mkidDataList,
                      context: context);
                  //Fuction to show snackbar
                  showSnackBarOnWrite(writeSuccessfull!);
                  //if data exists already
                  if (writeSuccessfull == -1 || writeSuccessfull == 0) {
                    return;
                  }

                  //make isnextclicked false
                  widget.makeNextClickedFalse(false);
                }
              },
              child: const ButtonBox(title: "ADD MK!ID")),
        ],
        const SizedBox(height: 50.0),
        if (widget.isTeam)
          SizedBox(
            height: 50.0,
          )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        scannedBarCode = scanData;
        participantData = json.decode(scannedBarCode!.code!);
      });

      // try {
      //   String token = scannedBarCode!.code!
      //       .substring(1, scannedBarCode!.code!.length - 1);
      //   Map<String, dynamic> qrText = await jwtDecryption(token);
      //   setState(() {
      //     status = qrText['name'];
      //   });
      //   List<String> obj = [
      //     qrText['kid'],
      //     ' ',
      //     qrText['name'],
      //     qrText['phone'],
      //     qrText['email'],
      //     // qrText['cegian'],
      //     qrText['college'],
      //     // qrText['roll'] ?? '',
      //   ];
      //   kIdList.add(obj);
      // } catch (e) {
      //   print(e);
      // }
      // controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}
