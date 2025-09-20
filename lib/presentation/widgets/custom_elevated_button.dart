import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isLoading;
  final bool isDisabled;
  final Color? color;
  final String title;
  final VoidCallback? onTap;

  const CustomElevatedButton({
    super.key,
    this.isLoading = false,
    this.isDisabled = false,
    this.color,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading || isDisabled ? null : onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(title),
    );
  }
}
