import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomOutlinedButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onTap, child: Text(title));
  }
}
