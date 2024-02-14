import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:pem/pem.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

List<List<String>> _data = [];

//read the public key from the assets folder
Future<String> readFileContents(String filePath) async {
  final fileContents = rootBundle.loadString(filePath);
  return fileContents;
}

//decrypt the JWT token
Future<Map<String, dynamic>> jwtDecryption(String token) async {
  String pem = await readFileContents('assets/public.pem').then(
    (value) => value.toString(),
  );

  List<int> keyData = PemCodec(PemLabel.publicKey).decode(pem);

  String pemBlock = PemCodec(PemLabel.publicKey).encode(keyData);

  final publicKey = RSAPublicKey(pemBlock);

  final jwt = JWT.verify(token, publicKey);
  String decryptedString = jwt.payload['id'];
  Map<String, dynamic> qrText = jsonDecode(decryptedString);
  print(qrText);
  return qrText;
}

//check if the participant is paid or not
bool isPaid({required String event, required Map<String, dynamic> eventList}) {
  String normalizedEvent = event.replaceAll(' ', '');
  bool isPaid = eventList[normalizedEvent] ?? false;
  return isPaid;
}

String capitalizeAllWord(String value) {
  value = value.toLowerCase();
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}

//create a CSV file for the event
void createFile({required String eventName}) async {
  if (await Permission.manageExternalStorage.isGranted) {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Directory rootPath = Directory('/storage/emulated/0');
    Directory kEventsFolder = Directory('${rootPath.path}/KEvents');

    if (!kEventsFolder.existsSync()) {
      kEventsFolder.createSync();
    }

    File file = File('${kEventsFolder.path}/$eventName.csv');
    if (!file.existsSync()) {
      file.createSync();
      prefs.setInt('teamNo', 0);
      //Write the header for CSV File
      writeListToCsv(data: [
        'Team No',
        'KID',
        'Name',
        'Email',
        'Phone',
        'College',
        'CEGIAN'
      ], isHeader: true, isTeam: false, isFirstParticipant: false);
    }
    prefs.setString('filePath', file.path);
  } else {
    await Permission.manageExternalStorage.request();
  }
}

//add the participant details to the _data variable
Future<int> writeListToCsv({
  required List<String> data,
  bool isHeader = false,
  required bool isTeam,
  required bool isFirstParticipant,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final openedCsvData = await readDataFromCSV();

  //Check for dupicates
  for (var row in openedCsvData) {
    if (row[1].toString() == data[1]) {
      print(data[1]);
      return -1;
    }
  }
  //Get teamno
  int teamNo = 1;
  String teamNoStr = (openedCsvData.isEmpty)
      ? "1"
      : (openedCsvData[openedCsvData.length - 1][0]
          .toString()
          .replaceFirst("Team - ", "0"));
  teamNo = int.tryParse(teamNoStr) ?? 0;
  //Update team number
  if (isTeam) {
    if (isFirstParticipant) {
      print(teamNo);
      teamNo += 1;
    }
  } else {
    teamNo += 1;
  }
  //Add data
  if (!isHeader) {
    data[0] = 'Team - $teamNo';
    //data[i].insert(0, 'Team - $teamNo');
  }
  _data.add(data);
  //add teamno and kid to local storage
  // print("$teamNo  ${data[0]}");
  // await prefs.setInt("teamNo", teamNo);
  // await prefs.setString("kid", data[0]);

  print("LIST: $_data");

  //Function to add the data to the CSV File
  return await _writeDataToCSV();
}

//write the participant details to the CSV file
Future<int> _writeDataToCSV() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('filePath');
    final File file = File(path!);
    final csvDataSet = await file.readAsString();
    final List<List<dynamic>> temp =
        const CsvToListConverter().convert(csvDataSet);
    final List<List<String>> dataList =
        temp.map((row) => row.map((cell) => cell.toString()).toList()).toList();
    // print("Datalist: $dataList");
    dataList.addAll(_data);

    String csvData = const ListToCsvConverter().convert(dataList);
    // print("CSV: $csvData");
    await file.writeAsString(csvData);

    _data.clear();
    return 1;
  } catch (err) {
    //todo: display a snackbar
    print(err);
    return 0;
  }
}

//read the CSV file
Future<List<List<dynamic>>> readDataFromCSV() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? path = prefs.getString('filePath');
  File file = File(path!);
  List<List<dynamic>> data;
  try {
    final csvString = await file.readAsString();
    final csvTable = const CsvToListConverter().convert(csvString);
    data =
        csvTable.map((row) => row.map((e) => e as dynamic).toList()).toList();
  } catch (e) {
    print(e);
    return [];
  }
  return data;
}

//delete the participant details from the CSV file
Future<bool> removeParticipantDetail({
  required String kid,
}) {
  try {
    //get the CSV data
    readDataFromCSV().then(
      (value) {
        // int index = value.indexWhere((element) => element[1] == kid);
        // value.removeAt(index);
        // writeListToCsv(data: value as List<List<String>>);
      },
    );
    return Future.value(true);
  } catch (err) {
    print(err);
    return Future.value(false);
  }
}

Future<int> removeDataTeamNo({required int teamNo}) async {
  print(teamNo);
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('filePath');
    final File file = File(path!);

    final csvDataSet = await file.readAsString();
    final List<List<dynamic>> temp =
        const CsvToListConverter().convert(csvDataSet);

    String teamNoStr = "";
    int csvTeamNo;
    List<List<dynamic>> remove = [];
    List<List<dynamic>> removedData = temp;
    for (var row in temp) {
      teamNoStr = "";
      teamNoStr = (row[0].toString().replaceFirst("Team - ", "0"));
      csvTeamNo = int.tryParse(teamNoStr) ?? 0;
      if (teamNo == csvTeamNo) {
        remove.add(row);
      }
    }

    removedData.removeWhere((element) => remove.contains(element));

    final List<List<String>> dataList = removedData
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();

    String csvData = const ListToCsvConverter().convert(dataList);
    // print("CSV: $csvData");
    await file.writeAsString(csvData);

    _data.clear();
    return 1;
  } catch (err) {
    //todo: display a snackbar
    print(err);
    return 0;
  }
}

Future<int> removeDataList({
  required List<List<dynamic>> data,
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('filePath');
    final File file = File(path!);

    final csvDataSet = await file.readAsString();
    List<List<dynamic>> temp = const CsvToListConverter().convert(csvDataSet);

    temp.removeRange(1, temp.length);
    temp.addAll(data);
    print(temp);

    final List<List<String>> dataList =
        temp.map((row) => row.map((cell) => cell.toString()).toList()).toList();
    print(dataList);
    String csvData = const ListToCsvConverter().convert(dataList);
    // print("CSV: $csvData");
    await file.writeAsString(csvData);

    _data.clear();
    return 1;
  } catch (err) {
    //todo: display a snackbar
    print(err);
    return 0;
  }
}
