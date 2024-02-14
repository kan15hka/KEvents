import 'package:flutter/material.dart';

import 'package:kevents/common/utils/utils.dart';
import 'package:kevents/features/event_screen/search/send_file_button.dart';
import 'package:kevents/features/event_screen/search/participant_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSearchParticipantPage extends StatefulWidget {
  const ViewSearchParticipantPage({super.key});

  @override
  State<ViewSearchParticipantPage> createState() =>
      _ViewSearchParticipantPageState();
}

class _ViewSearchParticipantPageState extends State<ViewSearchParticipantPage> {
  TextEditingController searchController = TextEditingController();
  String? filePath;
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> searchData = [];
  List<dynamic> csvHeader = [
    "TEAM NO",
    "KID",
    "NAME",
    "EMAIL",
    "PHONE",
    "COLLEGE",
    "IS CEGIAN"
  ];
  bool isKIDPresent = true;

  void _loadCSV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filePath = prefs.getString('filePath');
    print(filePath);
    readDataFromCSV().then(
      (value) => setState(() {
        csvData = value;
        if (csvData.length <= 1) {
          searchData = [];
        } else {
          searchData = csvData.sublist(1);
        }
      }),
    );
  }

  //search participant by KID
  void searchParticipant(String searchtext) {
    int index = csvData[0].indexOf("KID");
    searchData.clear();
    List<List<dynamic>> data = csvData.sublist(1);
    int falseCount = 0;
    for (var csvRow in data) {
      if (csvRow[index]
          .toString()
          .toLowerCase()
          .startsWith(searchtext.toLowerCase())) {
        setState(() {
          searchData.add(csvRow);
        });
      } else {
        setState(() {
          falseCount++;
        });
      }
    }
    setState(() {
      if (falseCount < data.length) {
        isKIDPresent = true;
      } else {
        isKIDPresent = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
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
            SizedBox(
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                onChanged: ((value) {
                  searchParticipant(value);
                }),
                style: const TextStyle(color: Colors.white, fontSize: 17.0),
                controller: searchController,
                decoration: textFieldInputDecoration,
              ),
            ),
            SendFileButton(filePath: filePath),
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
          isKIDPresent: isKIDPresent,
        ),
        const SizedBox(
          height: 100.0,
        )
      ],
    );
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
  hintText: 'Search by K! ID',
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
