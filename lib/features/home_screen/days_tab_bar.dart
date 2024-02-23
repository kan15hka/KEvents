// import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:kevents/common/utils/utils.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:kevents/common/widgets/frosted_glass_event_box.dart';
import 'package:kevents/common/widgets/search_textfield.dart';
import 'package:kevents/models/events.dart';
import 'package:kevents/features/home_screen/day_tab.dart';
import 'package:kevents/features/event_screen/navigation/navigation.dart';
import 'package:lottie/lottie.dart';
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
  List<List<Map<String, dynamic>>> ogEvents = events;

  List<Map<String, dynamic>> searchEvents = [];
  @override
  void initState() {
    currentIndex = 0;
    searchEvents = events[currentIndex];
    ogEvents = events;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> dayTabItem = ["EVENTS", "WORKSHOPS"];
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

  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<Map<String, dynamic>> search = [];
  void onSearchEvents(String searchText) {
    print(searchText);
    search.clear();
    if (ogEvents.isNotEmpty) {
      setState(() {
        searchEvents = events[currentIndex].where((event) {
          return event['title']
              .toLowerCase()
              .contains(searchText.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isProcessingFile)
        ? const Center(
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
                          _pageController.jumpToPage(
                            index,
                            // duration: const Duration(milliseconds: 300),
                            // curve: Curves.ease,
                          );
                        });
                      },
                      child: DayTab(
                        isSelected: (index == currentIndex) ? true : false,
                        day: day,
                      ),
                    );
                  }).toList()),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 60.0,
                child: SearchTextFormField(
                  labelText: 'Search event',
                  controller: searchController,
                  onChanged: onSearchEvents,
                ),
              ),
              Expanded(
                child: (isSearching)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PageView(
                        controller: _pageController,
                        onPageChanged: (int index) {
                          setState(() {
                            currentIndex = index;
                            searchEvents = events[currentIndex];
                          });
                        },
                        children: events.map((dayEvents) {
                          if (searchEvents.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  LottieBuilder.asset(
                                    "assets/images/empty.json",
                                    height: 200.0,
                                    width: 200.0,
                                  ),
                                  const Text("No events found!")
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                itemCount: searchEvents.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> eventMap =
                                      searchEvents[index];
                                  int eventIndex =
                                      events[currentIndex].indexOf(eventMap);
                                  print(searchEvents);

                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isProcessingFile = true;
                                      });
                                      await _clearPreferences();
                                      createFolderAndCSVFile(
                                          eventMap["title"]!);
                                      setState(() {
                                        isProcessingFile = false;
                                        _filePath;
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationWidget(
                                                  event: eventMap["title"]!,
                                                  count: eventMap["count"] ?? 1,
                                                  code: eventMap["code"] ?? ""),
                                        ),
                                      );
                                    },
                                    child: FrostedGlassEventBox(
                                      boxIndex: eventIndex,
                                      boxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.85,
                                      verticalBoxMargin: 15.0,
                                      boxCount: eventMap["count"] ?? 1,
                                      boxTitle: eventMap["title"]!,
                                    ),
                                  );
                                });
                          }
                        }).toList()),
              ),
            ],
          );
  }
}
