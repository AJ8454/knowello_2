import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      hintColor: Theme.of(context).primaryColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).primaryColor,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ];

  @override
  Widget buildResults(BuildContext context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      );
}
