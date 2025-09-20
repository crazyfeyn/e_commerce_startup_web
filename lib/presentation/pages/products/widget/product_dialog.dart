import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart' hide TitleData;
import 'package:e_commerce_startup_web/data/models/measurement_model.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';
import 'package:e_commerce_startup_web/data/models/upload_image_model.dart';
import 'package:e_commerce_startup_web/data/repositories/category_repository_impl.dart';
import 'package:e_commerce_startup_web/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_drop_down_menu.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_elevated_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDialog extends StatefulWidget {
  final ProductModel? product;
  final Function(List<UploadImageModel>, ProductModel)? onTap;

  const ProductDialog({super.key, this.product, this.onTap});

  static productShowDialog({
    required BuildContext context,
    ProductModel? product,
    Function(List<UploadImageModel>, ProductModel)? onTap,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return ProductDialog(product: product, onTap: onTap);
      },
    );
  }

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _catRepo = CategoryRepositoryImpl();
  final _catPro = ProductRepositoryImpl();

  final _formKey = GlobalKey<FormState>();
  final _brandCtr = TextEditingController();
  final _priceCtr = TextEditingController();
  final _amountCtr = TextEditingController();
  final _currencyCtr = TextEditingController();
  final _nameUzCtr = TextEditingController();
  final _nameKrCtr = TextEditingController();
  final _nameEnCtr = TextEditingController();
  final _promptCtr = TextEditingController();

  List<CategoryModel> categories = [];
  bool isLoadingCat = true;
  int? selectCategory;

  List<MeasurementModel> measurements = [];
  bool isLoadingMeasurement = true;
  int? selectMeasurement;

  List<UploadImageModel> files = [];

  Future<void> fetchCategories() async {
    final result = await _catRepo.fetchCategories();
    if (result.isRight()) {
      categories = result.getOrElse(() => throw Exception("Unexpected error"));
    }
    isLoadingCat = false;
    if (mounted) setState(() {});
  }

  Future<void> fetchMeasurements() async {
    final result = await _catPro.fetchMeasurements();
    if (result.isRight()) {
      measurements = result.getOrElse(
        () => throw Exception("Unexpected error"),
      );
    }
    isLoadingMeasurement = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _brandCtr.text = widget.product?.brand ?? "";
    _priceCtr.text = widget.product?.price?.toString() ?? "";
    _amountCtr.text = widget.product?.amount?.toString() ?? "";
    _currencyCtr.text = widget.product?.currency ?? "";
    _nameUzCtr.text = widget.product?.titleData?.uz ?? "";
    _nameKrCtr.text = widget.product?.titleData?.kor ?? "";
    _nameEnCtr.text = widget.product?.titleData?.en ?? "";
    _promptCtr.text = widget.product?.description ?? "";
    selectCategory = widget.product?.categoryId;
    selectMeasurement = widget.product?.measurementId;

    fetchCategories();
    fetchMeasurements();
    super.initState();
  }

  @override
  void dispose() {
    _catRepo.dispose();
    _catPro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
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
                      widget.product != null
                          ? context.tr(LocaleKeys.edit_product)
                          : context.tr(LocaleKeys.add_product),
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
                        CustomDropDownMenu(
                          isSearch: true,
                          isLoadingFetch: isLoadingCat,
                          title: context.tr(LocaleKeys.product_category_title),
                          hint: context.tr(LocaleKeys.product_category_title),
                          id: categories.isNotEmpty
                              ? selectCategory?.toString()
                              : null,
                          items: List.generate(categories.length, (index) {
                            final e = categories[index];
                            return DropDownItem(
                              e.id?.toString() ?? "",
                              e.titleData?.getTitle(
                                    context.locale.languageCode,
                                  ) ??
                                  "",
                            );
                          }),
                          onSelect: (value) {
                            selectCategory = int.tryParse(value ?? "");
                            if (mounted) setState(() {});
                          },
                        ),

                        CustomTextField(
                          ctr: _brandCtr,
                          title: context.tr(LocaleKeys.product_brand_title),
                          hintText: context.tr(LocaleKeys.product_brand_hint),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _priceCtr,
                          keyboardType: TextInputType.number,
                          title: context.tr(LocaleKeys.product_price_title),
                          hintText: context.tr(LocaleKeys.product_price_hint),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _currencyCtr,
                          title: context.tr(LocaleKeys.product_currency_title),
                          hintText: context.tr(
                            LocaleKeys.product_currency_hint,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _amountCtr,
                          keyboardType: TextInputType.number,
                          title: context.tr(LocaleKeys.product_amount_title),
                          hintText: context.tr(LocaleKeys.product_amount_hint),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),

                        CustomDropDownMenu(
                          isSearch: true,
                          isLoadingFetch: isLoadingMeasurement,
                          title: context.tr(
                            LocaleKeys.product_measurement_title,
                          ),
                          hint: context.tr(LocaleKeys.product_measurement_hint),
                          id: measurements.isNotEmpty
                              ? selectMeasurement?.toString()
                              : null,
                          items: List.generate(measurements.length, (index) {
                            final e = measurements[index];
                            return DropDownItem(
                              e.id?.toString() ?? "",
                              e.title ?? "",
                            );
                          }),
                          onSelect: (value) {
                            selectMeasurement = int.tryParse(value ?? "");
                            if (mounted) setState(() {});
                          },
                        ),

                        CustomTextField(
                          ctr: _nameUzCtr,
                          title: context.tr(LocaleKeys.product_name_uz_title),
                          hintText: context.tr(LocaleKeys.product_name_uz_hint),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _nameKrCtr,
                          title: context.tr(LocaleKeys.product_name_kr_title),
                          hintText: context.tr(LocaleKeys.product_name_kr_hint),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _nameEnCtr,
                          title: context.tr(LocaleKeys.product_name_en_title),
                          hintText: context.tr(LocaleKeys.product_name_en_hint),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),
                        CustomTextField(
                          ctr: _promptCtr,
                          title: context.tr(LocaleKeys.product_prompt_title),
                          hintText: context.tr(LocaleKeys.product_prompt_hint),
                          minLines: 4,
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr(LocaleKeys.empty_filed);
                            }

                            return null;
                          },
                        ),

                        Column(
                          children: List.generate(files.length, (index) {
                            final file = files[index];
                            return Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  size: 16,
                                  color: AppColors.black400,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    style: AppStyles.labelLGRegular,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    files.removeAt(index);
                                    if (mounted) setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: AppColors.black400,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),

                        if (widget.product?.id != null)
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true, withData: true);

                              if (result != null && result.files.isNotEmpty) {
                                files = result.files.map((f) => UploadImageModel(f.bytes!, f.name)).toList();
                                if(mounted) setState(() {});
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: Text(context.tr(LocaleKeys.upload_image)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomElevatedButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (selectCategory == null) return;
                    if (selectMeasurement == null) return;

                    final brand = _brandCtr.text.trim();
                    final price = double.tryParse(_priceCtr.text.trim());
                    final currency = _currencyCtr.text.trim();
                    final amount = double.tryParse(_amountCtr.text.trim());
                    final nameUz = _nameUzCtr.text.trim();
                    final nameKr = _nameKrCtr.text.trim();
                    final nameEn = _nameEnCtr.text.trim();
                    final prompt = _promptCtr.text.trim();

                    NavigationService.pop(context);
                    widget.onTap?.call(
                      files,
                      ProductModel(
                        id: widget.product?.id,
                        categoryId: selectCategory,
                        brand: brand,
                        price: price,
                        currency: currency,
                        amount: amount,
                        measurementId: selectMeasurement,
                        titleData: TitleData(
                          uz: nameUz,
                          kor: nameKr,
                          en: nameEn,
                        ),
                        description: prompt,
                      ),
                    );
                  }
                },
                title: widget.product != null
                    ? context.tr(LocaleKeys.edit_product)
                    : context.tr(LocaleKeys.add_product),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
