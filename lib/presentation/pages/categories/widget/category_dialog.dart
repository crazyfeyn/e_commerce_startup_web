import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class CategoryDialog {
  static Future<void> categoryShowDialog({
    required BuildContext context,
    CategoryModel? category,
    required Future<void> Function({
      required String uzTitle,
      required String enTitle,
      required String koTitle,
      required String prompt,
      int? categoryId,
      Uint8List? iconFile,
      String? iconFileName,
    })
    onTap,
  }) async {
    final uzController = TextEditingController(
      text: category?.titleData?.uz ?? '',
    );
    final enController = TextEditingController(
      text: category?.titleData?.en ?? '',
    );
    final koController = TextEditingController(
      text: category?.titleData?.kor ?? '',
    );
    final promptController = TextEditingController(
      text: category?.description ?? '',
    );

    final initialUz = uzController.text;
    final initialEn = enController.text;
    final initialKo = koController.text;
    final initialPrompt = promptController.text;
    final initialHasIcon = _hasExistingIcon(category);

    Uint8List? selectedImageBytes;
    String? selectedImageName;
    bool isUploading = false;
    bool hasChanges = false;

    void checkForChanges(StateSetter setState) {
      final changed =
          uzController.text.trim() != initialUz ||
          enController.text.trim() != initialEn ||
          koController.text.trim() != initialKo ||
          promptController.text.trim() != initialPrompt ||
          (selectedImageBytes != null) ||
          !initialHasIcon;

      setState(() {
        hasChanges = changed;
      });
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            uzController.addListener(() => checkForChanges(setState));
            enController.addListener(() => checkForChanges(setState));
            koController.addListener(() => checkForChanges(setState));
            promptController.addListener(() => checkForChanges(setState));

            return AlertDialog(
              title: Text(
                category == null
                    ? context.tr(LocaleKeys.create_category_title)
                    : context.tr(LocaleKeys.edit_category_title),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: uzController,
                        decoration: InputDecoration(
                          labelText: context.tr(
                            LocaleKeys.category_name_uz_title,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: enController,
                        decoration: InputDecoration(
                          labelText: context.tr(
                            LocaleKeys.category_name_en_title,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: koController,
                        decoration: InputDecoration(
                          labelText: context.tr(
                            LocaleKeys.category_name_kr_title,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: promptController,
                        decoration: InputDecoration(
                          labelText: context.tr(
                            LocaleKeys.category_prompt_title,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.tr(LocaleKeys.category_icon),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            if (selectedImageBytes != null) ...[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    selectedImageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedImageName ??
                                    context.tr(LocaleKeys.selected_image),
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ] else if (category != null &&
                                _hasExistingIcon(category)) ...[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: NetworkImageLoader(
                                    url: _getIconUrl(category),
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr(LocaleKeys.current_icon),
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ] else ...[
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.image,
                                      withData: true,
                                    );
                                if (result != null &&
                                    result.files.single.bytes != null) {
                                  setState(() {
                                    selectedImageBytes =
                                        result.files.single.bytes;
                                    selectedImageName =
                                        result.files.single.name;
                                  });
                                  checkForChanges(setState);
                                }
                              },
                              icon: const Icon(Icons.upload),
                              label: Text(
                                selectedImageBytes != null ||
                                        _hasExistingIcon(category)
                                    ? context.tr(LocaleKeys.change_icon)
                                    : context.tr(LocaleKeys.upload_icon),
                              ),
                            ),
                            if (selectedImageBytes != null) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedImageBytes = null;
                                    selectedImageName = null;
                                  });
                                  checkForChanges(setState);
                                },
                                child: Text(
                                  context.tr(LocaleKeys.remove_selected_image),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isUploading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(context.tr(LocaleKeys.cancel)),
                ),
                ElevatedButton(
                  onPressed: isUploading
                      ? null
                      : category == null || hasChanges
                      ? () async {
                          if (uzController.text.trim().isEmpty ||
                              enController.text.trim().isEmpty ||
                              koController.text.trim().isEmpty ||
                              promptController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr(
                                    LocaleKeys.please_fill_required_fields,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isUploading = true;
                          });

                          try {
                            Navigator.of(context).pop();
                            await onTap(
                              uzTitle: uzController.text.trim(),
                              enTitle: enController.text.trim(),
                              koTitle: koController.text.trim(),
                              prompt: promptController.text.trim(),
                              categoryId: category?.id,
                              iconFile: selectedImageBytes,
                              iconFileName: selectedImageName,
                            );
                          } catch (e) {
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category != null && !hasChanges
                        ? Colors.grey
                        : null,
                  ),
                  child: isUploading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text(context.tr(LocaleKeys.processing)),
                          ],
                        )
                      : Text(
                          category == null
                              ? context.tr(LocaleKeys.create)
                              : context.tr(LocaleKeys.update),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static bool _hasExistingIcon(CategoryModel? category) {
    return category?.imageIdentity != null &&
        category!.imageIdentity!.isNotEmpty;
  }

  static String _getIconUrl(CategoryModel category) {
    return "${NetworkService.getService}${NetworkService.apiFileDownload(category.imageIdentity!)}";
  }
}
