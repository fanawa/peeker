import 'package:flutter/material.dart';
import 'package:idz/themes/light_theme.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator(
      {Key? key, this.backgroundColor, this.foregroundColor, this.value})
      : super(key: key);

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