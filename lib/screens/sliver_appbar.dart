import 'package:flutter/material.dart';
import 'package:knowello_ui/models/image_model.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider/theme_provider.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  State<CustomSliverAppBar> createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<CustomSliverAppBar> {
  bool showTabBarBody = false;
  List<Widget> tabs = [];
  List<Widget> tabsBody = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 2), () {
  //     loadtabs();
  //   });
  // }

  // loadtabs() async {
  //   tabs = List.generate(
  //       3,
  //       (index) => const Tab(
  //             text: '#Oneplus',
  //           ));
  //   tabsBody = List.generate(
  //     10,
  //     (index) => const BodyWidget(),
  //   );
  //   setState(() => isLoading = false);
  // }

  int cardScrollIndex = 0;

  List<Post>? allpost;
  List<Widget>? images;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isThemeOn = themeProvider.isDarkMode;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text('knowello'),
              actions: [
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: themeProvider.isDarkMode
                        ? Colors.amber
                        : Colors.blueGrey,
                  ),
                  onPressed: () {
                    setState(() => isThemeOn = !isThemeOn);
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toogleTheme(isThemeOn);
                  },
                ),
              ],
              // bottom: PreferredSize(
              //   preferredSize: const Size.fromHeight(45),
              //   child: Container(
              //     width: double.infinity,
              //     color: Theme.of(context).appBarTheme.backgroundColor,
              //     child: Stack(
              //       children: [
              //         Row(
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   setState(() => showTabBarBody = false);
              //                 },
              //                 child: SizedBox(
              //                   child: Center(
              //                     child: Column(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         const Spacer(),
              //                         Text(
              //                           'Trending',
              //                           style: TextStyle(
              //                             color: Theme.of(context).primaryColor,
              //                             fontSize: fontSize(context)! * 14,
              //                           ),
              //                         ),
              //                         const Spacer(),
              //                         Container(
              //                           color: showTabBarBody
              //                               ? null
              //                               : Theme.of(context).primaryColor,
              //                           height: 2,
              //                           width: width(context)! * 0.2,
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Expanded(
              //               flex: 3,
              //               child: TabBar(
              //                 labelColor: Theme.of(context).iconTheme.color,
              //                 labelStyle:
              //                     TextStyle(fontSize: fontSize(context)! * 14),
              //                 unselectedLabelColor:
              //                     Theme.of(context).iconTheme.color,
              //                 indicatorSize: TabBarIndicatorSize.label,
              //                 indicatorColor: showTabBarBody
              //                     ? Theme.of(context).primaryColor
              //                     : Theme.of(context)
              //                         .appBarTheme
              //                         .backgroundColor,
              //                 isScrollable: true,
              //                 onTap: (index) {
              //                   setState(() => showTabBarBody = true);
              //                 },
              //                 tabs: tabs,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ],
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : DefaultTabController(
                  length: tabsBody.length,
                  child: const TabBarView(
                    children: [
                      Center(
                        child: Text('data'),
                      ),
                      Center(
                        child: Text('data'),
                      ),
                      Center(
                        child: Text('data'),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
