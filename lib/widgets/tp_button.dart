import 'package:flutter/material.dart';

class TpButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const TpButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: onPressed, child: Text(label));
}
