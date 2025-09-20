import 'package:e_commerce_startup_web/core/services/lang_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_assets.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/models/language_model.dart';
import 'package:e_commerce_startup_web/presentation/widgets/construction_bottom_sheet.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatefulWidget {
  final VoidCallback? onTap;

  const LanguageBottomSheet({super.key, this.onTap});

  static showBottomSheet({required BuildContext context, VoidCallback? onTap}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return LanguageBottomSheet(onTap: onTap);
      },
    );
  }

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  List<LanguageModel> languages = [];
  String? oldLangCode;
  String? langCode;

  @override
  void initState() {
    super.initState();
    languages = LangService.getLanguages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    langCode = context.locale.languageCode;
    oldLangCode = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return ConstructionBottomSheet(
      isDivider: false,
      title: context.tr(LocaleKeys.change_language),
      actions: [
        BottomSheetAction(
          color: AppColors.black500,
          icon: AppAssets.icons.icClose,
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
      buttons: [
        BottomSheetButton(
          onTap: () {
            if(langCode != null && langCode != oldLangCode) {
              LangService.changeLocale(context, langCode!);
              Navigator.of(context).pop();
              widget.onTap?.call();
            }
          },
          type: BottomSheetButtonType.elevated,
          title: context.tr(LocaleKeys.save_btn),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: List.generate(languages.length, (index) {
            final language = languages[index];
            final isSelect = language.languageCode == langCode;
            return LanguageCard(
              isSheet: true,
              isSelect: isSelect,
              language: languages[index],
              onTap: () => setState(() => langCode = language.languageCode),
            );
          }),
        ),
      ),
    );
  }
}


class LanguageCard extends StatelessWidget {
  final bool isSheet;
  final bool isSelect;
  final LanguageModel language;
  final VoidCallback? onTap;

  const LanguageCard({
    super.key,
    this.isSheet = false,
    required this.isSelect,
    required this.language,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AppColors.black50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSheet && isSelect ? BorderSide(width: 1, color: AppColors.primary500) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 8,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: CustomSvg(icon: language.icon, size: 24),
                ),
                Expanded(child: Text(language.name, style: AppStyles.bodyMDRegular)),
                Checkbox(
                  value: isSelect,
                  onChanged: (value) => onTap?.call(),
                  shape: CircleBorder(),
                  side: BorderSide(width: 1, color: AppColors.black500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}