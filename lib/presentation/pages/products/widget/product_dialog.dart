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
      barrierDismissible: false,
      builder: (_) => ProductDialog(product: product, onTap: onTap),
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

  List<UploadImageModel> newImages = [];
  String? categoryError;
  String? measurementError;
  String? fileError;

  bool isUploading = false;

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

  Future<void> fetchCategories() async {
    final result = await _catRepo.fetchCategories();
    if (result.isRight()) {
      categories = result.getOrElse(
        () => throw Exception("Failed to load categories"),
      );
    }
    isLoadingCat = false;
    if (mounted) setState(() {});
  }

  Future<void> fetchMeasurements() async {
    final result = await _catPro.fetchMeasurements();
    if (result.isRight()) {
      measurements = result.getOrElse(
        () => throw Exception("Failed to load measurements"),
      );
    }
    isLoadingMeasurement = false;
    if (mounted) setState(() {});
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
    if (widget.product == null && newImages.isEmpty) {
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
        newImages.addAll(newFiles);
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

  void _removeNewImage(int index) {
    newImages.removeAt(index);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isEdit
                          ? CupertinoIcons.pencil_circle
                          : CupertinoIcons.plus_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Product' : 'New Product',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          isEdit
                              ? context.tr(LocaleKeys.edit_product)
                              : context.tr(LocaleKeys.add_product),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: isUploading
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 18,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildSectionTitle(
                        context,
                        "Basic Information",
                        CupertinoIcons.info_circle,
                      ),
                      const SizedBox(height: 12),
                      CustomDropDownMenu(
                        isSearch: true,
                        isLoadingFetch: isLoadingCat,
                        title: context.tr(LocaleKeys.product_category_title),
                        hint: context.tr(LocaleKeys.product_category_title),
                        id: categories.isNotEmpty
                            ? selectCategory?.toString()
                            : null,
                        items: categories
                            .map(
                              (e) => DropDownItem(
                                e.id?.toString() ?? "",
                                e.titleData?.getTitle(
                                      context.locale.languageCode,
                                    ) ??
                                    "",
                              ),
                            )
                            .toList(),
                        onSelect: (value) {
                          selectCategory = int.tryParse(value ?? "");
                          categoryError = null;
                          if (mounted) setState(() {});
                        },
                      ),
                      if (categoryError != null)
                        _buildErrorText(categoryError!),
                      const SizedBox(height: 12),
                      CustomTextField(
                        ctr: _brandCtr,
                        title: context.tr(LocaleKeys.product_brand_title),
                        hintText: context.tr(LocaleKeys.product_brand_hint),
                        validator: (v) => (v == null || v.isEmpty)
                            ? context.tr(LocaleKeys.empty_filed)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              ctr: _priceCtr,
                              keyboardType: TextInputType.number,
                              title: context.tr(LocaleKeys.product_price_title),
                              hintText: context.tr(
                                LocaleKeys.product_price_hint,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return context.tr(LocaleKeys.empty_filed);
                                if (double.tryParse(v) == null)
                                  return context.tr(
                                    LocaleKeys.please_enter_valid_number,
                                  );
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              ctr: _currencyCtr,
                              title: context.tr(
                                LocaleKeys.product_currency_title,
                              ),
                              hintText: context.tr(
                                LocaleKeys.product_currency_hint,
                              ),
                              validator: (v) => (v == null || v.isEmpty)
                                  ? context.tr(LocaleKeys.empty_filed)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              ctr: _amountCtr,
                              keyboardType: TextInputType.number,
                              title: context.tr(
                                LocaleKeys.product_amount_title,
                              ),
                              hintText: context.tr(
                                LocaleKeys.product_amount_hint,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return context.tr(LocaleKeys.empty_filed);
                                if (double.tryParse(v) == null)
                                  return context.tr(
                                    LocaleKeys.please_enter_valid_number,
                                  );
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropDownMenu(
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
                              items: measurements
                                  .map(
                                    (e) => DropDownItem(
                                      e.id?.toString() ?? "",
                                      e.title ?? "",
                                    ),
                                  )
                                  .toList(),
                              onSelect: (value) {
                                selectMeasurement = int.tryParse(value ?? "");
                                measurementError = null;
                                if (mounted) setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      if (measurementError != null)
                        _buildErrorText(measurementError!),
                      const SizedBox(height: 20),

                      // Localization Section
                      _buildSectionTitle(
                        context,
                        "Localization",
                        CupertinoIcons.globe,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        ctr: _nameUzCtr,
                        title: context.tr(LocaleKeys.product_name_uz_title),
                        hintText: context.tr(LocaleKeys.product_name_uz_hint),
                        validator: (v) => (v == null || v.isEmpty)
                            ? context.tr(LocaleKeys.empty_filed)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        ctr: _nameKrCtr,
                        title: context.tr(LocaleKeys.product_name_kr_title),
                        hintText: context.tr(LocaleKeys.product_name_kr_hint),
                        validator: (v) => (v == null || v.isEmpty)
                            ? context.tr(LocaleKeys.empty_filed)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        ctr: _nameEnCtr,
                        title: context.tr(LocaleKeys.product_name_en_title),
                        hintText: context.tr(LocaleKeys.product_name_en_hint),
                        validator: (v) => (v == null || v.isEmpty)
                            ? context.tr(LocaleKeys.empty_filed)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        ctr: _promptCtr,
                        title: context.tr(LocaleKeys.product_prompt_title),
                        hintText: context.tr(LocaleKeys.product_prompt_hint),
                        minLines: 3,
                        maxLines: 5,
                        validator: (v) => (v == null || v.isEmpty)
                            ? context.tr(LocaleKeys.empty_filed)
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Images Section
                      _buildSectionTitle(
                        context,
                        "Product Images",
                        CupertinoIcons.photo,
                      ),
                      const SizedBox(height: 12),
                      _buildImageSection(),
                    ],
                  ),
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FC),
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isUploading
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        context.tr(LocaleKeys.cancel),
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: isUploading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate() &&
                                  _validateDropdowns()) {
                                final brand = _brandCtr.text.trim();
                                final price = double.tryParse(
                                  _priceCtr.text.trim(),
                                );
                                final currency = _currencyCtr.text.trim();
                                final amount = double.tryParse(
                                  _amountCtr.text.trim(),
                                );
                                final nameUz = _nameUzCtr.text.trim();
                                final nameKr = _nameKrCtr.text.trim();
                                final nameEn = _nameEnCtr.text.trim();
                                final prompt = _promptCtr.text.trim();

                                setState(() => isUploading = true);
                                Navigator.of(context).pop();
                                await widget.onTap?.call(
                                  newImages,
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
                                setState(() => isUploading = false);
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        disabledBackgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isUploading
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text("Processing..."),
                              ],
                            )
                          : Text(
                              isEdit
                                  ? context.tr(LocaleKeys.update)
                                  : context.tr(LocaleKeys.create),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: Colors.orange.shade600),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final hasExistingImages =
        widget.product?.images != null && widget.product!.images!.isNotEmpty;
    final hasNewImages = newImages.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload button
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.upload, size: 16),
              label: Text(context.tr(LocaleKeys.add_images)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          if (fileError != null) ...[
            const SizedBox(height: 8),
            _buildErrorText(fileError!),
          ],
          const SizedBox(height: 12),

          // Existing images (only for edit)
          if (hasExistingImages) ...[
            Text(
              context.tr(LocaleKeys.existing_images),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: widget.product!.images!.length,
              itemBuilder: (context, index) {
                final imageId = widget.product!.images![index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: NetworkImageLoader(
                    url:
                        "${NetworkService.getService}${NetworkService.apiFileDownload(imageId)}",
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // New images to upload
          if (hasNewImages) ...[
            Text(
              widget.product != null
                  ? context.tr(LocaleKeys.new_images_to_upload)
                  : context.tr(LocaleKeys.selected_images),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(newImages.length, (index) {
                final file = newImages[index];
                return Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          file.file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => _removeNewImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(
                LocaleKeys.file_size_kb,
                namedArgs: {
                  'size':
                      (newImages.fold<int>(0, (sum, f) => sum + f.file.length) /
                              1024)
                          .toStringAsFixed(1),
                },
              ),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
