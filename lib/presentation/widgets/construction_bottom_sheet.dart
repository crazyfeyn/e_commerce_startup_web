import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_elevated_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_outlined_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_svg.dart';
import 'package:flutter/material.dart';

enum BottomSheetButtonType { outline, elevated }

class BottomSheetAction {
  final Color color;
  final String icon;
  final VoidCallback? onTap;

  BottomSheetAction({required this.color, required this.icon, this.onTap});
}

class BottomSheetButton {
  final BottomSheetButtonType type;
  final Color? color;
  final String title;
  final VoidCallback? onTap;

  BottomSheetButton({this.type = BottomSheetButtonType.elevated, this.color, required this.title, this.onTap});
}

class ConstructionBottomSheet extends StatelessWidget {
  final bool isDivider;
  final List<BottomSheetAction>? actions;
  final List<BottomSheetButton>? buttons;
  final String title;
  final Widget child;

  const ConstructionBottomSheet({
    super.key,
    this.isDivider = true,
    required this.title,
    required this.child,
    this.actions,
    this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: MediaQuery.viewPaddingOf(context).bottom + 8),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 16,
          alignment: WrapAlignment.start,
          children: [
            Column(
              spacing: 16,
              children: [
                Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.black500,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.titleSMSemibold,
                      ),
                    ),
                    if(actions != null)
                      ...List.generate(actions!.length, (index) {
                        final action = actions![index];
                        return _action(
                          color: action.color,
                          icon: action.icon,
                          onTap: action.onTap,
                        );
                      })
                  ],
                ),
              ],
            ),
            if(isDivider) Divider(),
            child,
            if(buttons != null && buttons!.isNotEmpty)
              ...[
                if(isDivider) Divider(),
                Row(
                  spacing: 8,
                  children: List.generate(buttons!.length, (index) {
                    final button = buttons![index];
                    if(button.type == BottomSheetButtonType.outline) {
                      return Expanded(
                        child: CustomOutlinedButton(onTap: button.onTap, title: button.title),
                      );
                    }

                    return Expanded(
                      child: CustomElevatedButton(
                        onTap: button.onTap,
                        title: button.title,
                        color: button.color,
                      ),
                    );
                  }),
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget _action({
    required VoidCallback? onTap,
    required String icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomSvg(size: 20, icon: icon, color: color),
      ),
    );
  }
}
