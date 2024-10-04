import 'package:flutter/material.dart';

class CreateItemButton extends StatelessWidget {
  const CreateItemButton({
    super.key,
    required this.onPressed,
  });

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
