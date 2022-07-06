import 'package:flutter/material.dart';
import 'package:knowello_ui/screens/menu_screen.dart';
import 'package:knowello_ui/screens/story_types/bookmark_stories.dart';
import 'package:knowello_ui/screens/story_types/buzzing_stories.dart';
import 'package:knowello_ui/screens/story_types/knowables_stories.dart';
import 'package:knowello_ui/screens/story_types/popular_stories.dart';
import 'package:knowello_ui/screens/timeline_screen.dart';
import 'package:knowello_ui/widgets/error_page.dart';
import 'package:knowello_ui/widgets/tab_bar.dart';
import 'package:knowello_ui/widgets/web_view_widget.dart';

Route<dynamic>? myRouting(RouteSettings settings) {
  final arguments = settings.arguments;
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const TabBarWidget());
    case '/webViewPage':
      return MaterialPageRoute(
        builder: (_) => WebViewWidget(url: '$arguments'),
      );
    case '/MenuPage':
      return MaterialPageRoute(
        builder: (_) => const MenuScreen(),
      );
    case '/popularStory':
      return MaterialPageRoute(
        builder: (_) => const PopularStories(),
      );
    case '/knowableStory':
      return MaterialPageRoute(
        builder: (_) => const KnowablesStories(),
      );
    case '/buzzingStory':
      return MaterialPageRoute(
        builder: (_) => const BuzzingStories(),
      );
    case '/timeline':
      return MaterialPageRoute(
        builder: (_) => const TimeLineScreen(),
      );
    case '/bookmarkPage':
      return MaterialPageRoute(
        builder: (_) => const BookMarkStories(),
      );
    default:
      return errorRoute();
  }
}
