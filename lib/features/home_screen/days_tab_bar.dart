// import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:kevents/common/utils/utils.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:kevents/common/widgets/frosted_glass_event_box.dart';
import 'package:kevents/models/events.dart';
import 'package:kevents/features/home_screen/day_tab.dart';
import 'package:kevents/features/event_screen/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaysTabBar extends StatefulWidget {
  const DaysTabBar({super.key});

  @override
  State<DaysTabBar> createState() => _DaysTabBarState();
}

class _DaysTabBarState extends State<DaysTabBar> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool isProcessingFile = false;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> dayTabItem = ["DAY 1", "DAY 2", "DAY 3"];
  String? eventType;
  //File
  String? path;
  String? _filePath; //Selected File Path
  // String? _folderPath;
  bool isFileSelected = false; //File Selected or Not

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('fileSelected', true);
    prefs.setString('eventType', eventType!);
    setState(() {
      _filePath = prefs.getString('filePath');
      isFileSelected = prefs.getBool('fileSelected')!;
    });
  }

  Future<void> createFolderAndCSVFile(String event) async {
    try {
      createFile(eventName: event);
      await _loadPreferences();
    } catch (e) {
      print('Error creating folder and CSV file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isProcessingFile)
        ? const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Processing File",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          )
        : Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dayTabItem.map((day) {
                    int index = dayTabItem.indexOf(day);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      },
                      child: DayTab(
                        isSelected: (index == currentIndex) ? true : false,
                        day: day,
                      ),
                    );
                  }).toList()),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Select an event to proceed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    children: events
                        .map(
                          (dayEvents) => ListView(
                            //controller: _controller,
                            physics: const BouncingScrollPhysics(),
                            children: events[currentIndex].map((eventMap) {
                              int eventIndex =
                                  events[currentIndex].indexOf(eventMap);

                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isProcessingFile = true;
                                  });
                                  createFolderAndCSVFile(eventMap["title"]!);
                                  setState(() {
                                    isProcessingFile = false;
                                    eventType = eventMap["type"]!;
                                    _filePath;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationWidget(
                                                  event: eventMap["title"]!,
                                                  eventType: eventType!)));
                                },
                                child: FrostedGlassEventBox(
                                    boxIndex: eventIndex,
                                    boxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                    verticalBoxMargin: 15.0,
                                    boxType: eventMap["type"]!,
                                    boxTitle: eventMap["title"]!),
                              );
                            }).toList(),
                          ),
                        )
                        .toList()),
              ),
            ],
          );
  }
}
