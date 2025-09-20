import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatefulWidget {
  final bool isExpanded;
  final bool isBorder;
  final bool isSearch;
  final bool isLoadingFetch;
  final String? title;
  final String? hint;
  final String? id;
  final List<DropDownItem> items;
  final Function(String?) onSelect;

  const CustomDropDownMenu({
    super.key,
    this.isExpanded = true,
    this.isBorder = true,
    this.isSearch = false,
    this.isLoadingFetch = false,
    this.title,
    this.hint,
    required this.id,
    required this.items,
    required this.onSelect,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  final TextEditingController textEditingController = TextEditingController();
  List<DropDownItem> items = [];
  DropDownItem? selectItem;

  onValue(String? id) {
    if (id == null) return null;
    for (var e in items) {
      if (e.id == id) return e;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    items = widget.items;
    selectItem = onValue(widget.id);
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant CustomDropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    items = widget.items;
    selectItem = onValue(widget.id);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: AppStyles.labelLGRegular.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        FormField<String>(
          initialValue: selectItem?.id,
          validator: (value) {
            if (value == null) {
              return context.tr(LocaleKeys.empty_filed);
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<DropDownItem>(
                    isExpanded: widget.isExpanded,
                    hint: Text(
                      widget.hint ?? "",
                      style: AppStyles.bodyMDRegular.copyWith(
                        color: AppColors.black500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: List.generate(items.length, (index) {
                      final item = items[index];
                      return DropdownMenuItem<DropDownItem>(
                        value: item,
                        child: Text(
                          item.title,
                          style: AppStyles.bodyMDRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                    value: selectItem,
                    onChanged: (e) {
                      widget.onSelect.call(e?.id);
                      state.didChange(e?.id);
                    },
                    iconStyleData: IconStyleData(
                      icon:
                      widget.isLoadingFetch
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ) : Icon(Icons.keyboard_arrow_down, color: AppColors.black500),
                    ),
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.black50,
                        borderRadius: BorderRadius.circular(12),
                        border: state.hasError ? Border.fromBorderSide(BorderSide(width: 0.5, color: Colors.red))
                            : widget.isBorder ? Border.fromBorderSide(Theme.of(context).inputDecorationTheme.focusedBorder!.borderSide) : null,
                      ),
                    ),
                    dropdownSearchData:
                    widget.isSearch
                        ? DropdownSearchData(
                      searchController: textEditingController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: widget.hint,
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value?.title ?? '')
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    )
                        : null,
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class DropDownItem {
  String id;
  String title;

  DropDownItem(this.id, this.title);
}