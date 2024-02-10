import 'package:flutter/material.dart';

class AddNewItemButton extends StatelessWidget {
  const AddNewItemButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: IconButton(
          icon: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
