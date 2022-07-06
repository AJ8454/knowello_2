import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:knowello_ui/screens/main_screens/home_screen.dart';
import 'package:knowello_ui/widgets/appbar_widget.dart';

String? routeToGo = '/';
int? appDBUserId = 442;
Box? exploreStoriesBox;

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final GlobalKey<HomeScreenState> homeStateglobalKey =
    GlobalKey<HomeScreenState>();

final GlobalKey<AppBarWidgetState> appBarglobalKey =
    GlobalKey<AppBarWidgetState>();
