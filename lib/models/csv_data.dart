//Packages
import 'dart:io';

//JWT Token Decryption
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/bottom_snackbar.dart';
import 'package:pem/pem.dart';
import 'package:flutter/services.dart' show rootBundle;

//CSV Package
import 'package:csv/csv.dart';

//Shared Preferences
import 'package:shared_preferences/shared_preferences.dart';

List<List<String>> data = [];

Future<String> readFileContents(String filePath) async {
  final fileContents = rootBundle.loadString(filePath);
  return fileContents;
}

jwtDecryption(String token) async {
  // Verify a token

  String pem = await readFileContents('assets/public.pem').then(
    (value) => value.toString(),
  );

  List<int> keyData = PemCodec(PemLabel.publicKey).decode(pem);

  String pemBlock = PemCodec(PemLabel.publicKey).encode(keyData);

  final publicKey = RSAPublicKey(pemBlock);
  try {
    final jwt = JWT.verify(token, publicKey);

    print('Payload: ${jwt.payload}');
    return jwt.payload['id'];
  } on JWTExpiredException {
    print('jwt expired');
  } on JWTException catch (ex) {
    print('Error : Decrypt -> ${ex.message}'); // ex: invalid signature
  }
}

Future<int> writeListtoCsv(
    {required String filePath,
    required List<dynamic> data,
    required BuildContext context,
    required bool isTeam,
    required bool isFirstParticipant}) async {
  try {
    print("sssss" + filePath);
    File file = File(filePath);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    // Read existing content if any
    final csvDataString = await file.readAsString();
    final List<List<dynamic>> csvData =
        const CsvToListConverter().convert(csvDataString);
    //Check whether dataexists already
    if (csvDataString.contains(data[1])) {
      print("Data Exists Already");
      return -1;
    }
    //create team no
    int? lastTeamNo;
    int? dataTeamNo = 1;
    //if file not empty
    if (csvData.length >= 2) {
      lastTeamNo = await int.parse(csvData[csvData.length - 1][0].toString());
      dataTeamNo = (lastTeamNo + 1);
    }
    //if is team and not first particpant toreapeat teamno
    if (isTeam && !isFirstParticipant) {
      dataTeamNo = await int.parse(
          csvData[csvData.length - 1][0].toString()); //last team no
    }
    data[0] = dataTeamNo.toString();

    //add csv data
    csvData.add(data);

    await file.writeAsString(const ListToCsvConverter().convert(csvData));
    //////

    print("Data Added Succesfully");
    if (isTeam) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('teamNo', dataTeamNo);
    }
    return 1;
  } catch (e) {
    print("Error Entering Data");
    return 0;
  }
}

// bool isTeamNew = false;
// if (isTeam && isFirstParticipant) {
//   isTeamNew = true;
// }
// print(isTeamNew);
// print(dataTeamNo);
//_loadPreferences(dataTeamNo, isTeamNew);

// void _loadPreferences(int teamNo, bool isTeamNew) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setInt('teamNo', teamNo);
//   int participantIndex = 0;
//   if (isTeamNew) {
//     participantIndex = 0;
//     prefs.setInt('participantIndex', participantIndex);
//   } else {
//     int participantIndex = prefs.getInt('participantIndex')!;
//     participantIndex += 1;
//     prefs.setInt('participantIndex', participantIndex);
//   }
//   print(participantIndex);
// }

Future<void> removeData(
    {required bool isTeamNo, required List<List<dynamic>> listData}) async {
  //get team no from shared prefernec
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? teamNo = prefs.getInt('teamNo');
  String? filePath = prefs.getString('filePath');
  //get file
  File file = File(filePath!);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  // Read existing content if any
  final csvDataString = await file.readAsString();
  List<List<dynamic>> csvData =
      const CsvToListConverter().convert(csvDataString);
  List<List<dynamic>> toRemove = [];
  //remove by teamno
  if (isTeamNo) {
    csvData.skip(1).forEach(
      (element) {
        if (int.parse(element[0].toString()) == teamNo) {
          toRemove.add(element);
        }
      },
    );
    csvData.removeWhere((e) => toRemove.contains(e));
  } else {
    if (listData.isNotEmpty) {
      listData.forEach((element) {
        toRemove.add(element);
      });
      () async {
        csvData.removeWhere((e) => toRemove.contains(e));
      };
    } else {
      print("d");
    }
  }

  print(csvData);
  await file.writeAsString(const ListToCsvConverter().convert(csvData));
}

Future<void> removeListAsync(
    List<List<dynamic>> listOfLists, List<dynamic> listToRemove) async {
  // Simulate an asynchronous operation (e.g., API call, database operation)
  await Future.delayed(Duration(seconds: 2));

  // Remove the specified list from the listOfLists
  listOfLists.remove(listToRemove);
}
