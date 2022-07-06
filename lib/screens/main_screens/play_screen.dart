import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text('Play',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
