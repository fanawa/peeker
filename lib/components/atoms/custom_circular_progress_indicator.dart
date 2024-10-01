import 'package:flutter/material.dart';
import 'package:peeker/themes/light_theme.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator(
      {super.key, this.backgroundColor, this.foregroundColor, this.value});

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
    );
  }
}
