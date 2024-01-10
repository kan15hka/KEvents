import 'package:flutter/material.dart';
import 'package:kevents/common/widgets/background_widget.dart';
import 'package:kevents/common/widgets/frosted_glass_box.dart';
import 'package:kevents/common/constants.dart';
import 'package:kevents/features/event_screen/search/send_file_button.dart';
import 'package:kevents/models/menu.dart';
import 'package:kevents/features/event_screen/navigation/btm_nav_item.dart';
import 'package:kevents/features/event_screen/participant/add_participant_page.dart';
import 'package:kevents/features/home_screen/home_screen.dart';
import 'package:kevents/features/event_screen/search/view_search_participant_page.dart';
import 'package:kevents/common/utils/rive_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/csv_data.dart';

class NavigationWidget extends StatefulWidget {
  final String event;
  final String eventType;
  const NavigationWidget(
      {super.key, required this.event, required this.eventType});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget>
    with SingleTickerProviderStateMixin {
  Menu selectedBottonNav = bottomNavItems.first;
  int selectedIndex = 0;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
        selectedIndex = bottomNavItems.indexOf(selectedBottonNav);
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  late List<Map<String, dynamic>> _pages;
  String? eventType;
  String? fpath;
  @override
  void initState() {
    eventType = widget.eventType;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _pages = [
      {
        'page': AddParticipantPage(
          eventType: eventType!,
        ),
        'title': 'Add ${eventType!.toString()} Participant',
      },
      {
        'page': ViewSearchParticipantPage(),
        'title': 'View or Search Participant',
      },
    ];
    super.initState();
  }

  @override
  void dispose() {
    data.clear();
    _clearPreferences();
    super.dispose();
  }

  void _clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('fileSelected', false);
    prefs.setString('filePath', '');
    prefs.setString('eventType', '');
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 20, 57),
      //backgorund widget
      body: BackgroundWidget(
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      //AppBar
                      Row(
                        children: [
                          //back Icon
                          GestureDetector(
                            onTap: () {
                              _clearPreferences();
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 30.0,
                                width: 60.0,
                                decoration: const BoxDecoration(
                                    //color: Colors.amber, shape: BoxShape.circle
                                    ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                          ),
                          //event Title
                          Expanded(
                            child: Container(
                              //color: Colors.red,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  widget.event,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 60.0,
                          )
                        ],
                      ),
                      //Bottom Nav Title
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: FrostedGlassBox(
                          boxHieght: 50.0,
                          boxWidth: MediaQuery.of(context).size.width,
                          borderRadius: 0.0,
                          isBorderRequired: false,
                          child: Center(
                            child: Text(
                              _pages[selectedIndex]["title"]
                                  .toString()
                                  .toUpperCase(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                      //Body
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: _pages[selectedIndex]["page"],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      //Bottom Navigation Bar and Send Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (keyboardIsOpened)
          ? null
          : SizedBox(
              height: 70.0,
              width: 250.0,
              child: Transform.translate(
                offset: Offset(0, 100 * animation.value),
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.2),
                          offset: const Offset(0, 20),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...List.generate(
                          bottomNavItems.length,
                          (index) {
                            Menu navBar = bottomNavItems[index];
                            return BtmNavItem(
                              navBar: navBar,
                              press: () {
                                RiveUtils.chnageSMIBoolState(
                                    navBar.rive.status!);
                                updateSelectedBtmNav(navBar);
                              },
                              riveOnInit: (artboard) {
                                navBar.rive.status = RiveUtils.getRiveInput(
                                    artboard,
                                    stateMachineName:
                                        navBar.rive.stateMachineName);
                              },
                              selectedNav: selectedBottonNav,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
