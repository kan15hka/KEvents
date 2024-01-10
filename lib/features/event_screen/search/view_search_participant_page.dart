import 'dart:io';
import 'package:csv/csv.dart';
import 'package:kevents/common/constants.dart';
import 'package:kevents/features/event_screen/search/send_file_button.dart';
import 'package:kevents/features/event_screen/search/participant_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class ViewSearchParticipantPage extends StatefulWidget {
  @override
  State<ViewSearchParticipantPage> createState() =>
      _ViewSearchParticipantPageState();
}

class _ViewSearchParticipantPageState extends State<ViewSearchParticipantPage> {
  bool isFileSelected = false;
  String? path;
  TextEditingController searchController = TextEditingController();
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> searchData = [];
  List<dynamic> csvHeader = [];
  bool isMKIDPresent = true;
  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isFileSelected = (prefs.getBool('fileSelected') ?? false);
      path = prefs.getString('filePath');
    });
    csvData = await readDataFromCSV();
    //Seperate Mkid array for earching
    csvHeader = csvData[0];
    searchData = csvData.sublist(1).toList();
  }

  //seperate mkid
  void searchParticipant(String searchtext) {
    int index = csvData[0].indexOf("MKID");
    searchData.clear();
    List<List<dynamic>> data = csvData.sublist(1);
    int falseCount = 0;
    data.forEach(
      (csvRow) {
        if (csvRow[index].toString().startsWith(searchtext)) {
          setState(() {
            searchData.add(csvRow);
          });
        } else {
          setState(() {
            falseCount++;
          });
        }
      },
    );
    setState(() {
      if (falseCount < data.length) {
        isMKIDPresent = true;
      } else {
        isMKIDPresent = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    //print(path);
    //seperateMKID();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        //Search Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SendFileButton(filePath: path),
            SizedBox(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                  onChanged: ((value) {
                    searchParticipant(value);
                  }),
                  style: const TextStyle(color: Colors.white, fontSize: 17.0),
                  controller: searchController,
                  decoration: textFieldInputDecoration),
            ),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),

        //Data Table
        ParticipantTable(
          csvData: csvData,
          headerData: csvHeader,
          cellData: searchData,
          isMKIDPresent: isMKIDPresent,
        ),
        SizedBox(
          height: 100.0,
        )
      ],
    );
  }

  Future<List<List<dynamic>>> readDataFromCSV() async {
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
}

InputDecoration textFieldInputDecoration = const InputDecoration(
  suffixIconColor: Color.fromARGB(179, 255, 255, 255),
  suffixIcon: Padding(
    padding: EdgeInsets.only(right: 5.0),
    child: Icon(
      Icons.search,
      size: 30.0,
    ),
  ),
  hintText: 'Search by MKID',
  hintStyle:
      TextStyle(color: Color.fromARGB(101, 255, 255, 255), fontSize: 17.0),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(width: 1.5, color: Color.fromARGB(100, 255, 255, 255)),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  ),
  fillColor: Color.fromARGB(20, 255, 255, 255),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: Colors.white),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: Colors.white),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
);
