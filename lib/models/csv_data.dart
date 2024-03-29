// //Packages
// import 'dart:io';

// //JWT Token Decryption
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:flutter/material.dart';
// import 'package:pem/pem.dart';
// import 'package:flutter/services.dart' show rootBundle;

// //CSV Package
// import 'package:csv/csv.dart';

// //Shared Preferences
// import 'package:shared_preferences/shared_preferences.dart';

// List<List<String>> data = [];

// //ReadFile Contents
// Future<String> readFileContents(String filePath) async {
//   final fileContents = rootBundle.loadString(filePath);
//   return fileContents;
// }

// //Jwt decryption
// dynamic jwtDecryption(String token) async {
//   String pem = await readFileContents('assets/public.pem').then(
//     (value) => value.toString(),
//   );

//   List<int> keyData = PemCodec(PemLabel.publicKey).decode(pem);

//   String pemBlock = PemCodec(PemLabel.publicKey).encode(keyData);

//   final publicKey = RSAPublicKey(pemBlock);
//   try {
//     final jwt = JWT.verify(token, publicKey);
//     return jwt.payload['id'];
//   } on JWTExpiredException {
//     print('jwt expired');
//   } on JWTException catch (ex) {
//     print('Error : Decrypt -> ${ex.message}'); // ex: invalid signature
//   }
// }

// //Write List to CSV
// Future<int> writeListtoCsv({
//   required List<dynamic> data,
//   required BuildContext context,
//   required bool isTeam,
//   required bool isFirstParticipant,
// }) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? filePath = prefs.getString('filePath');
//     print(filePath);
//     File file = File(filePath!);

//     if (!file.existsSync()) {
//       file.createSync(recursive: true);
//     }
//     // Read existing content if any
//     final csvDataString = await file.readAsString();
//     final List<List<dynamic>> csvData =
//         const CsvToListConverter().convert(csvDataString);
//     //Check whether dataexists already
//     if (csvDataString.contains(data[1])) {
//       print("Data Exists Already");
//       return -1;
//     }
//     //create team no
//     int? lastTeamNo;
//     int? dataTeamNo = 1;
//     //if file not empty
//     if (csvData.length >= 2) {
//       lastTeamNo = int.parse(csvData[csvData.length - 1][0].toString());
//       dataTeamNo = (lastTeamNo + 1);
//     }
//     //if is team and not first particpant toreapeat teamno
//     if (isTeam && !isFirstParticipant) {
//       dataTeamNo =
//           int.parse(csvData[csvData.length - 1][0].toString()); //last team no
//     }
//     data[0] = dataTeamNo.toString();

//     //add csv data
//     csvData.add(data);

//     await file.writeAsString(const ListToCsvConverter().convert(csvData));
//     //////

//     print("Data Added Succesfully");
//     if (isTeam) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setInt('teamNo', dataTeamNo);
//     }
//     return 1;
//   } catch (e) {
//     print("Error Entering Data");
//     return 0;
//   }
// }

// // Future<void> removeData(
// //     {required bool isTeamNo, required List<List<dynamic>> listData}) async {
// //   //get team no from shared prefernec
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   int? teamNo = prefs.getInt('teamNo');
// //   String? filePath = prefs.getString('filePath');
// //   //get file
// //   File file = File(filePath!);
// //   if (!file.existsSync()) {
// //     file.createSync(recursive: true);
// //   }
// //   // Read existing content if any
// //   final csvDataString = await file.readAsString();
// //   List<List<dynamic>> csvData =
// //       const CsvToListConverter().convert(csvDataString);
// //   List<List<dynamic>> toRemove = [];
// //   //remove by teamno
// //   if (isTeamNo) {
// //     csvData.skip(1).forEach(
// //       (element) {
// //         if (int.parse(element[0].toString()) == teamNo) {
// //           toRemove.add(element);
// //         }
// //       },
// //     );
// //     csvData.removeWhere((e) => toRemove.contains(e));
// //   } else {
// //     if (listData.isNotEmpty) {
// //       for (var element in listData) {
// //         toRemove.add(element);
// //       }
// //       () async {
// //         csvData.removeWhere((e) => toRemove.contains(e));
// //       };
// //     } else {
// //       //todo: do something
// //     }
// //   }

// //   print(csvData);
// //   await file.writeAsString(const ListToCsvConverter().convert(csvData));
// // }

// Future<void> removeListAsync(
//     List<List<dynamic>> listOfLists, List<dynamic> listToRemove) async {
//   // Simulate an asynchronous operation (e.g., API call, database operation)
//   await Future.delayed(const Duration(seconds: 2));

//   // Remove the specified list from the listOfLists
//   listOfLists.remove(listToRemove);
// }
