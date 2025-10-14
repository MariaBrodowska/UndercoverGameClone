import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isRevealed;

  const CardWidget({super.key, this.onTap, this.isRevealed = false});

  @override
  Widget build(BuildContext context) {
    if (isRevealed) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.indigo, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.visibility_off, size: 60, color: Colors.indigo),
        ),
      ),
    );
  }
}
