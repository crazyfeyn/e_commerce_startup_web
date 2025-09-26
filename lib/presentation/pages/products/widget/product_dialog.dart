import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart'
    hide TitleData;
import 'package:e_commerce_startup_web/data/models/measurement_model.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';
import 'package:e_commerce_startup_web/data/models/upload_image_model.dart';
import 'package:e_commerce_startup_web/data/repositories/category_repository_impl.dart';
import 'package:e_commerce_startup_web/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_drop_down_menu.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_elevated_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_text_field.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
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
  String? categoryError;
  String? measurementError;
  String? fileError;

  Future<void> fetchCategories() async {
    final result = await _catRepo.fetchCategories();
    if (result.isRight()) {
      categories = result.getOrElse(
        () => throw Exception(context.tr(LocaleKeys.dio_unknown_message)),
      );
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
    _brandCtr.dispose();
    _priceCtr.dispose();
    _amountCtr.dispose();
    _currencyCtr.dispose();
    _nameUzCtr.dispose();
    _nameKrCtr.dispose();
    _nameEnCtr.dispose();
    _promptCtr.dispose();
    super.dispose();
  }

  bool _validateDropdowns() {
    bool isValid = true;

    if (selectCategory == null) {
      categoryError = context.tr(LocaleKeys.empty_filed);
      isValid = false;
    } else {
      categoryError = null;
    }

    if (selectMeasurement == null) {
      measurementError = context.tr(LocaleKeys.empty_filed);
      isValid = false;
    } else {
      measurementError = null;
    }
    if (widget.product == null && files.isEmpty) {
      fileError = context.tr(LocaleKeys.please_select_image);
      isValid = false;
    } else {
      fileError = null;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newFiles = result.files
            .map((f) => UploadImageModel(f.bytes!, f.name))
            .toList();
        files.addAll(newFiles);
        fileError = null;
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.tr(
                LocaleKeys.error_selecting_files,
                namedArgs: {'error': e.toString()},
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
            SizedBox(height: 20),
            //? Form content
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropDownMenu(
                            isSearch: true,
                            isLoadingFetch: isLoadingCat,
                            title: context.tr(
                              LocaleKeys.product_category_title,
                            ),
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
                              categoryError = null;
                              if (mounted) setState(() {});
                            },
                          ),
                          if (categoryError != null)
                            Padding(
                              padding: EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                categoryError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
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

                      SizedBox(height: 12),

                      CustomTextField(
                        ctr: _priceCtr,
                        keyboardType: TextInputType.number,
                        title: context.tr(LocaleKeys.product_price_title),
                        hintText: context.tr(LocaleKeys.product_price_hint),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }
                          if (double.tryParse(value) == null) {
                            return context.tr(
                              LocaleKeys.please_enter_valid_number,
                            );
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        ctr: _currencyCtr,
                        title: context.tr(LocaleKeys.product_currency_title),
                        hintText: context.tr(LocaleKeys.product_currency_hint),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        ctr: _amountCtr,
                        keyboardType: TextInputType.number,
                        title: context.tr(LocaleKeys.product_amount_title),
                        hintText: context.tr(LocaleKeys.product_amount_hint),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr(LocaleKeys.empty_filed);
                          }
                          if (double.tryParse(value) == null) {
                            return context.tr(
                              LocaleKeys.please_enter_valid_number,
                            );
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      // Measurement dropdown with validation
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropDownMenu(
                            isSearch: true,
                            isLoadingFetch: isLoadingMeasurement,
                            title: context.tr(
                              LocaleKeys.product_measurement_title,
                            ),
                            hint: context.tr(
                              LocaleKeys.product_measurement_hint,
                            ),
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
                              measurementError = null;
                              if (mounted) setState(() {});
                            },
                          ),
                          if (measurementError != null)
                            Padding(
                              padding: EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                measurementError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 12),

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

                      SizedBox(height: 12),

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

                      SizedBox(height: 12),

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

                      SizedBox(height: 12),

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

                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    context.tr(LocaleKeys.upload_image),
                                    style: AppStyles.labelLGMedium,
                                  ),
                                  if (widget.product == null)
                                    Text(
                                      " *",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                  onPressed: _pickFiles,
                                  icon: const Icon(Icons.upload, size: 16),
                                  label: Text(
                                    context.tr(LocaleKeys.add_images),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (fileError != null)
                            Padding(
                              padding: EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                fileError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          SizedBox(height: 8),
                          //? for Update/editing
                          if (widget.product != null &&
                              widget.product!.images != null &&
                              widget.product!.images!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr(LocaleKeys.existing_images),
                                  style: AppStyles.labelSmMedium.copyWith(
                                    color: AppColors.black600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1,
                                      ),
                                  itemCount: widget.product!.images!.length,
                                  itemBuilder: (context, index) {
                                    final imageUrl =
                                        widget.product!.images![index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.black200,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: NetworkImageLoader(
                                          url:
                                              "${NetworkService.getService}${NetworkService.apiFileDownload(imageUrl)}",
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                          if (files.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product != null
                                      ? context.tr(
                                          LocaleKeys.new_images_to_upload,
                                        )
                                      : context.tr(LocaleKeys.selected_images),
                                  style: AppStyles.labelSmMedium.copyWith(
                                    color: AppColors.black600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Column(
                                  children: List.generate(files.length, (
                                    index,
                                  ) {
                                    final file = files[index];
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.black200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.image,
                                              size: 20,
                                              color: AppColors.primary600,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  file.name,
                                                  style:
                                                      AppStyles.labelLGMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  context.tr(
                                                    LocaleKeys.file_size_kb,
                                                    namedArgs: {
                                                      'size':
                                                          (file.file.length /
                                                                  1024)
                                                              .toStringAsFixed(
                                                                1,
                                                              ),
                                                    },
                                                  ),
                                                  style: AppStyles
                                                      .labelSmRegular
                                                      .copyWith(
                                                        color:
                                                            AppColors.black500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              files.removeAt(index);
                                              if (mounted) setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: AppColors.red500,
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //? Submit button
            CustomElevatedButton(
              onTap: () {
                if (_formKey.currentState!.validate() && _validateDropdowns()) {
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
                      titleData: TitleData(uz: nameUz, kor: nameKr, en: nameEn),
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
    );
  }
}
