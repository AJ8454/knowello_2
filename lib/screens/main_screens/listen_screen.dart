import 'package:flutter/material.dart';

class ListenScreen extends StatelessWidget {
  const ListenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text('Listen',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
