import 'dart:developer';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:knowello_ui/models/appbar_banner_model.dart';
import 'package:knowello_ui/providers/appbar_banner_provider/appbar_banner_provider.dart';
import 'package:knowello_ui/providers/local_pref/store_local_preference.dart';
import 'package:knowello_ui/providers/theme_provider/theme_provider.dart';
import 'package:knowello_ui/utils/global_keys.dart';
import 'package:knowello_ui/widgets/my_search_delegate.dart';
import 'package:provider/provider.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:validators/validators.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget> {
  List hottagList = [];
  String? bannerName = '';
  bool? autoplay = false;
  int? whattoShow;
  bool loading = true;

  @override
  void initState() {
    loadBanner();
    super.initState();
  }

  update() async {
    await loadBanner();
  }

  loadBanner() async {
    setState(() => loading = true);
    final provider = Provider.of<AppBarBannerProvider>(context, listen: false);
    await APICacheManager().isAPICacheKeyExist("appBarBannerkey");

    AppBarBannerModel data = await provider.getbanners();
    hottagList = data.data!;
    bannerName = data.bannerName!;
    whattoShow = data.whatToShow!;
    setState(() => loading = false);
    //   if (networkStatus == NetworkStatus.online) { } else {
    //   var cacheData = await APICacheManager().getCacheData('appBarBannerkey');
    //   AppBarBannerModel appBarBannerModel =
    //       AppBarBannerModel.fromJson(jsonDecode(cacheData.syncData));
    //   hottagList = appBarBannerModel.data!;
    //   bannerName = appBarBannerModel.bannerName!;
    //   whattoShow = appBarBannerModel.whatToShow!;
    //   setState(() => loading = false);
    // }
  }

  updateAll() async {
    await loadBanner();
    await homeStateglobalKey.currentState?.update();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isThemeOn = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/MenuPage');
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/timeline'),
            icon: const Icon(Icons.timeline),
          ),
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () => updateAll(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.blueGrey,
            ),
            onPressed: () {
              setState(() => isThemeOn = !isThemeOn);
              LocalPreference.setThemeMode(isThemeOn);
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toogleTheme(isThemeOn);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: SizedBox(
            height: 35,
            child: loading
                ? LinearProgressIndicator(
                    color: const Color(0xff32B8CB),
                    minHeight: 2,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                  )
                : Row(
                    children: [
                      whattoShow == 1 || whattoShow == 0
                          ? const SizedBox.shrink()
                          : Flexible(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xff32B8CB),
                                  // borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    bannerName!,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Expanded(
                        flex: 2,
                        child: whattoShow == 1
                            ? ScrollLoopAutoScroll(
                                scrollDirection: Axis.horizontal,
                                delay: const Duration(milliseconds: 1),
                                duration: const Duration(seconds: 400),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    hottagList.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        if (isURL(hottagList[index].link)) {
                                          log(hottagList[index].link);
                                          Navigator.pushNamed(
                                              context, '/webViewPage',
                                              arguments:
                                                  hottagList[index].link);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            border: Border(
                                          right: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2,
                                          ),
                                        )),
                                        child: RichText(
                                          text: TextSpan(
                                            text: '${bannerName!}:',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    ' ${hottagList[index].title}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(bottom: 5),
                                itemCount: hottagList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {},
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          " ${whattoShow == 2 ? '' : '#'}${hottagList[index].title}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
