import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final bool readOnly;
  final String? title;
  final String? hintText;
  final TextEditingController ctr;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final Color? color;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffix;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.readOnly = false,
    this.title,
    this.hintText,
    required this.ctr,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.obscureText = false,
    this.color,
    this.minLines,
    this.maxLines = 1,
    this.suffixIcon,
    this.onSuffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: AppStyles.labelLGRegular.copyWith(color: AppColors.black400),
          ),
        TextFormField(
          controller: ctr,
          minLines: minLines,
          maxLines: maxLines,
          obscuringCharacter: "*",
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: AppStyles.bodyMDRegular,
          decoration: InputDecoration(
            fillColor: color,
            hintText: hintText,
            suffixIcon:
                suffixIcon != null
                    ? IconButton(
                      onPressed: onSuffix,
                      icon: Icon(suffixIcon, size: 18, color: AppColors.black500),
                    )
                    : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
