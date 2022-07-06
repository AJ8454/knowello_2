import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:knowello_ui/providers/network_service.dart';
import 'package:knowello_ui/screens/main_screens/home_screen.dart';
import 'package:knowello_ui/screens/main_screens/listen_screen.dart';
import 'package:knowello_ui/screens/main_screens/play_screen.dart';
import 'package:knowello_ui/screens/main_screens/read_screen.dart';
import 'package:knowello_ui/screens/main_screens/watch_screen.dart';
import 'package:knowello_ui/screens/story_types/buzzing_stories.dart';
import 'package:knowello_ui/screens/story_types/knowables_stories.dart';
import 'package:knowello_ui/screens/story_types/popular_stories.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/utils/global_keys.dart';
import 'package:knowello_ui/widgets/appbar_widget.dart';
import 'package:knowello_ui/models/check_box_state.dart';
import 'package:provider/provider.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({Key? key}) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  String selectedReadScreen = 'All';
  int currentIndex = 0;
  final checkboxNotify = [
    CheckBoxState(title: 'All', icon: Icons.article_outlined, value: true),
    CheckBoxState(title: 'Buzzing', icon: Icons.bubble_chart, value: false),
    CheckBoxState(
        title: 'Knowable', icon: Icons.accessibility_new_sharp, value: false),
    CheckBoxState(title: 'Popular', icon: Icons.safety_check, value: false),
  ];

  updateAll() async {
    await appBarglobalKey.currentState?.update();
    await homeStateglobalKey.currentState?.update();
  }

  @override
  void initState() {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Consumer<ConnectivityProvider>(builder: (context, model, child) {
          return model.isOnline!
              ? const AppBarWidget()
              : Center(
                  child: Text('No Internet',
                      style: themeTextStyle(context: context)),
                );
        }),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(key: homeStateglobalKey),
          selectedReadScreen == 'All'
              ? const ReadScreen()
              : selectedReadScreen == 'Buzzing'
                  ? const BuzzingStories(showAppBar: false)
                  : selectedReadScreen == 'Knowable'
                      ? const KnowablesStories(showAppBar: false)
                      : const PopularStories(showAppBar: false),
          const ListenScreen(),
          const WatchScreen(),
          const PlayScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onLongPress: () async {
                await showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (builder) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Container(
                          height: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                          child: Center(
                            child: ListView.builder(
                              itemCount: checkboxNotify.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  secondary: Icon(checkboxNotify[index].icon,
                                      color: Theme.of(context).primaryColor),
                                  title: Text(
                                    checkboxNotify[index].title!,
                                    style: themeTextStyle(context: context),
                                  ),
                                  value: checkboxNotify[index].value,
                                  onChanged: (value) {
                                    for (var element in checkboxNotify) {
                                      element.value = false;
                                    }
                                    setState(() =>
                                        checkboxNotify[index].value = value);
                                    selectedReadScreen =
                                        checkboxNotify[index].title!;
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      });
                    }).then((_) {
                  log(selectedReadScreen);
                  setState(() {});
                });
              },
              child: const Icon(Icons.chrome_reader_mode_outlined),
            ),
            label: selectedReadScreen == "All" ? 'Read' : selectedReadScreen,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: 'Listen',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Watch',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Play',
          ),
        ],
      ),
    );
  }
}
