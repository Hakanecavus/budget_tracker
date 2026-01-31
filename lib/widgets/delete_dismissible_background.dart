import 'package:flutter/material.dart';

class DeleteDismissibleBackground extends StatelessWidget {
  const DeleteDismissibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
