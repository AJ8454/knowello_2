import 'package:flutter/material.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/widgets/rounded_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu', style: themeTextStyle(context: context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Center(
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  RoundedCustomButton(
                    title: 'Popular',
                    onClicked: () {
                      Navigator.pushNamed(context, '/popularStory');
                    },
                  ),
                  RoundedCustomButton(
                    title: 'Buzzing',
                    onClicked: () {
                      Navigator.pushNamed(context, '/buzzingStory');
                    },
                  ),
                  RoundedCustomButton(
                    title: 'Knowables',
                    onClicked: () {
                      Navigator.pushNamed(context, '/knowableStory');
                    },
                  ),
                  RoundedCustomButton(
                    title: 'Videos',
                    onClicked: () {},
                  ),
                  RoundedCustomButton(
                    title: 'Play',
                    onClicked: () {},
                  ),
                  RoundedCustomButton(
                    title: 'Bookmark',
                    onClicked: () {
                      Navigator.pushNamed(context, '/bookmarkPage');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
