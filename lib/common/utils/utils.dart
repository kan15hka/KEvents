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
dynamic jwtDecryption(String token) async {
  String pem = await readFileContents('assets/public.pem').then(
    (value) => value.toString(),
  );

  List<int> keyData = PemCodec(PemLabel.publicKey).decode(pem);

  String pemBlock = PemCodec(PemLabel.publicKey).encode(keyData);

  final publicKey = RSAPublicKey(pemBlock);
  try {
    final jwt = JWT.verify(token, publicKey);
    print(jwt.payload['id']);
    return jwt.payload['id'];
  } on JWTExpiredException {
    print('jwt expired');
  } on JWTException catch (ex) {
    //todo: display a snackbar
    print('Error : Decrypt -> ${ex.message}'); // ex: invalid signature
  }
}

//check if the participant is paid or not
bool isPaid({required String event, required Map<String, dynamic> eventList}) {
  final normalizedEvent = event.replaceAll(' ', '');
  final isPaid = eventList[normalizedEvent];
  return isPaid ?? false;
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
      prefs.setInt('teamNo', 1);
      //Write the header for CSV File
      writeListToCsv(
        data: [
          ['Team No', 'KID', 'Name', 'Email', 'Phone', 'College', 'CEGIAN']
        ],
        isHeader: true,
      );
    }
    prefs.setString('filePath', file.path);
  } else {
    await Permission.manageExternalStorage.request();
  }
}

//add the participant details to the _data variable
Future<int> writeListToCsv({
  required List<List<String>> data,
  bool isHeader = false,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int teamNo = prefs.getInt('teamNo')!;
  for (int i = 0; i < data.length; i++) {
    if (!isHeader) data[i].insert(0, 'Team - $teamNo');
    _data.add(data[i]);
  }

  // print("LIST: $_data");

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
    int teamNo = prefs.getInt('teamNo')!;
    prefs.setInt('teamNo', teamNo + 1);
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
        print(value);
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
