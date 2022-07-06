import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowello_ui/providers/local_pref/store_local_preference.dart';
import 'package:knowello_ui/providers/theme_provider/theme_provider.dart';
import 'package:knowello_ui/utils/global_keys.dart';
import 'package:knowello_ui/utils/provider_registers.dart';
import 'package:knowello_ui/utils/routing.dart';
import 'package:knowello_ui/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPreference.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode? active;
  DisplayMode? preferred;

  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   // fetchAll();
    // });
  }

  Future<void> fetchAll() async {
    try {
      modes = await FlutterDisplayMode.supported;
    } on PlatformException catch (e) {
      log('$e');
    }

    preferred = await FlutterDisplayMode.preferred;

    active = await FlutterDisplayMode.active;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providerRegisters,
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            navigatorKey: navigatorKey,
            themeMode: themeProvider.themeMode,
            theme: MyThemeData.lightTheme,
            darkTheme: MyThemeData.darkTheme,
            initialRoute: routeToGo ?? '/',
            // home: const TabBarWidget(),
            onGenerateRoute: myRouting,
          );
        });
  }
}
