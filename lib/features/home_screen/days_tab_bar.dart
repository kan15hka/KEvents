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
  //File
  String? path;
  String? _filePath; //Selected File Path
  // String? _folderPath;
  bool isFileSelected = false; //File Selected or Not

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('fileSelected', true);
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

  Future<void> _clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('fileSelected', false);
    prefs.setString('filePath', '');
    prefs.setInt("teamNo", 0);
    prefs.setString('kid', '');
  }

  @override
  Widget build(BuildContext context) {
    return (isProcessingFile)
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
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
                            padding: EdgeInsets.only(bottom: 25.0, top: 10.0),
                            physics: const BouncingScrollPhysics(),
                            children: events[currentIndex].map((eventMap) {
                              int eventIndex =
                                  events[currentIndex].indexOf(eventMap);

                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isProcessingFile = true;
                                  });
                                  await _clearPreferences();
                                  createFolderAndCSVFile(eventMap["title"]!);
                                  setState(() {
                                    isProcessingFile = false;
                                    _filePath;
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavigationWidget(
                                          event: eventMap["title"]!,
                                          count: eventMap["count"] ?? 1,
                                          code: eventMap["code"] ?? ""),
                                    ),
                                  );
                                },
                                child: FrostedGlassEventBox(
                                  boxIndex: eventIndex,
                                  boxWidth:
                                      MediaQuery.of(context).size.width * 0.85,
                                  verticalBoxMargin: 15.0,
                                  boxCount: eventMap["count"] ?? 1,
                                  boxTitle: eventMap["title"]!,
                                ),
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
