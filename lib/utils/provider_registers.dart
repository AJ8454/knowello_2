import 'package:knowello_ui/providers/appbar_banner_provider/appbar_banner_provider.dart';
import 'package:knowello_ui/providers/network_service.dart';
import 'package:knowello_ui/providers/reel_provider/knowello_reel_provider.dart';
import 'package:knowello_ui/providers/story_provider/story_provider.dart';
import 'package:knowello_ui/providers/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providerRegisters {
  return [
    ChangeNotifierProvider(create: (ctx) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
    ChangeNotifierProvider(create: (ctx) => AppBarBannerProvider()),
    ChangeNotifierProvider(create: (ctx) => StoryProvider()),
    ChangeNotifierProvider(create: (ctx) => KnowelloReelProvider()),
  ];
}
