import 'package:flutter/material.dart';
import 'package:peeker/themes/light_theme.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.onPressed,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;

  final double? size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? primaryColor,
      radius: 12,
      child: IconButton(
        onPressed: onPressed ?? () {},
        icon: const Icon(Icons.cancel),
        iconSize: size ?? 15,
      ),
    );
  }
}
