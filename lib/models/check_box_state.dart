import 'package:flutter/material.dart';

class CheckBoxState {
  final String? title;
  final IconData? icon;
  bool? value;

  CheckBoxState({
    required this.title,
    required this.icon,
    this.value = false,
  });
}
