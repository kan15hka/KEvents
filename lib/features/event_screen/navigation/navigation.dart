import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:kevents/common/widgets/background_widget.dart';
import 'package:kevents/common/widgets/frosted_glass_box.dart';
import 'package:kevents/models/menu.dart';
import 'package:kevents/features/event_screen/navigation/btm_nav_item.dart';
import 'package:kevents/features/event_screen/participant/add_participant_page.dart';
import 'package:kevents/features/event_screen/search/view_search_participant_page.dart';
import 'package:kevents/common/utils/rive_utils.dart';

class NavigationWidget extends StatefulWidget {
  final String event;
  final int count;
  final String code;
  const NavigationWidget(
      {super.key,
      required this.event,
      required this.count,
      required this.code});

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
  int? eventCount;
  String? fpath;
  @override
  void initState() {
    eventCount = widget.count;
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
          eventName: widget.event,
          count: widget.count,
          code: widget.code,
        ),
        'title': 'Add Participant',
      },
      {
        'page': const ViewSearchParticipantPage(),
        'title': 'View or Search Participant',
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 24, 20, 57),
      //backgorund widget
      body: BackgroundWidget(
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    //AppBar
                    GlassContainer(
                      blur: 10,
                      color: Colors.white.withOpacity(0.1),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.blue.withOpacity(0.6),
                        ],
                      ),
                      //--code to remove border
                      border: const Border.fromBorderSide(BorderSide.none),
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        //color: Colors.red,
                        constraints: const BoxConstraints(minHeight: 100.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 45.0,
                            ),
                            Row(
                              children: [
                                //back Icon
                                GestureDetector(
                                  onTap: () {
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
                                    //color: Colors.amber,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      widget.event.toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 60.0,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Bottom Nav Title
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
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
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Body
                    Expanded(
                      child: SizedBox(
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
