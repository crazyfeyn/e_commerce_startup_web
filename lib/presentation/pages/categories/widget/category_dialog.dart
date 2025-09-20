import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_elevated_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryDialog extends StatefulWidget {
  final CategoryModel? category;
  final Function({
    int? categoryId,
    required String uzTitle,
    required String enTitle,
    required String koTitle,
    required String prompt,
  })?
  onTap;

  const CategoryDialog({super.key, this.category, this.onTap});

  static categoryShowDialog({
    required BuildContext context,
    CategoryModel? category,
    Function({
      int? categoryId,
      required String uzTitle,
      required String enTitle,
      required String koTitle,
      required String prompt,
    })?
    onTap,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return CategoryDialog(category: category, onTap: onTap);
      },
    );
  }

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameUzCtr = TextEditingController();
  final _nameKrCtr = TextEditingController();
  final _nameEnCtr = TextEditingController();
  final _promptCtr = TextEditingController();

  @override
  void initState() {
    _nameUzCtr.text = widget.category?.titleData?.uz ?? "";
    _nameKrCtr.text = widget.category?.titleData?.kor ?? "";
    _nameEnCtr.text = widget.category?.titleData?.en ?? "";
    _promptCtr.text = widget.category?.description ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        child: Column(
          spacing: 20,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.category == null
                        ? context.tr(LocaleKeys.add_category)
                        : context.tr(LocaleKeys.edit_category),
                    style: AppStyles.bodyLGMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => NavigationService.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white100,
                    maximumSize: Size(32, 32),
                    minimumSize: Size(32, 32),
                    shape: CircleBorder(),
                  ),
                  icon: Icon(
                    CupertinoIcons.clear,
                    size: 16,
                    color: AppColors.black950,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 12,
                    children: [
                      CustomTextField(
                        ctr: _nameUzCtr,
                        title: context.tr(LocaleKeys.category_name_uz_title),
                        hintText: context.tr(LocaleKeys.category_name_uz_hint),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }

                          return null;
                        },
                      ),
                      CustomTextField(
                        ctr: _nameKrCtr,
                        title: context.tr(LocaleKeys.category_name_kr_title),
                        hintText: context.tr(LocaleKeys.category_name_kr_hint),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }

                          return null;
                        },
                      ),
                      CustomTextField(
                        ctr: _nameEnCtr,
                        title: context.tr(LocaleKeys.category_name_en_title),
                        hintText: context.tr(LocaleKeys.category_name_en_hint),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }

                          return null;
                        },
                      ),

                      CustomTextField(
                        ctr: _promptCtr,
                        title: context.tr(LocaleKeys.category_prompt_title),
                        hintText: context.tr(LocaleKeys.category_prompt_hint),
                        minLines: 4,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomElevatedButton(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  final uzTitle = _nameUzCtr.text.trim();
                  final enTitle = _nameEnCtr.text.trim();
                  final koTitle = _nameKrCtr.text.trim();
                  final prompt = _promptCtr.text.trim();
                  widget.onTap?.call(
                    categoryId: widget.category?.id,
                    uzTitle: uzTitle,
                    enTitle: enTitle,
                    koTitle: koTitle,
                    prompt: prompt,
                  );
                  NavigationService.pop(context);
                }
              },
              title: widget.category == null
                  ? context.tr(LocaleKeys.add_category)
                  : context.tr(LocaleKeys.edit_category),
            ),
          ],
        ),
      ),
    );
  }
}
