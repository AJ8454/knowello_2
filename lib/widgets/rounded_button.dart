import 'package:flutter/material.dart';

class RoundedCustomButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onClicked;
  const RoundedCustomButton({
    Key? key,
    this.onClicked,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ),
      onPressed: onClicked,
      child: Text(title!),
    );
  }
}
