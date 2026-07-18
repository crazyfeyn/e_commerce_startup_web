import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class CategoryDialog {
  static Future<void> categoryShowDialog({
    required BuildContext context,
    CategoryModel? category,
    required Future<void> Function({
      required String titleEn,
      required String prompt,
      int? categoryId,
      Uint8List? iconFile,
      String? iconFileName,
    })
    onTap,
  }) async {
    final titleEnController = TextEditingController(
      text: category?.titleData?.en ?? '',
    );
    final promptController = TextEditingController(
      text: category?.description ?? '',
    );

    final initialTitleEn = titleEnController.text;
    final initialPrompt = promptController.text;
    final initialHasIcon = _hasExistingIcon(category);

    Uint8List? selectedImageBytes;
    String? selectedImageName;
    bool isUploading = false;
    bool hasChanges = false;

    void checkForChanges(StateSetter setState) {
      final changed =
          titleEnController.text.trim() != initialTitleEn ||
          promptController.text.trim() != initialPrompt ||
          (selectedImageBytes != null) ||
          (selectedImageBytes == null && !initialHasIcon);
      setState(() => hasChanges = changed);
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            titleEnController.addListener(() => checkForChanges(setState));
            promptController.addListener(() => checkForChanges(setState));

            final isEdit = category != null;
            final canSave = !isUploading && (!isEdit || hasChanges);

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: MediaQuery.of(ctx).size.width * 0.44,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ───────────────────────────────────────────────
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
                                  isEdit ? 'Edit Category' : 'New Category',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  isEdit ? 'Edit category' : "Create category",
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
                                : () => Navigator.of(ctx).pop(),
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

                    // ── Body ─────────────────────────────────────────────────
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info Banner
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFED7AA),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.sparkles,
                                    size: 14,
                                    color: Color(0xFFF97316),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Enter category name in English. The backend will automatically translate it to all supported languages (Uzbek, Korean, etc.) using Anthropic AI.",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.orange.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Category Name (English only - source for translation)
                            _buildTextField(
                              controller: titleEnController,
                              label: "Category Name (English)",
                              hintText:
                                  "e.g. Electronics, Clothing, Fresh Food",
                              enabled: !isUploading,
                            ),
                            const SizedBox(height: 16),

                            // Prompt / Description (for Anthropic context)
                            _buildTextField(
                              controller: promptController,
                              label: 'Description',
                              hintText:
                                  "Describe what this category is about. This helps AI generate accurate translations.",
                              icon: CupertinoIcons.text_alignleft,
                              maxLines: 3,
                              enabled: !isUploading,
                            ),
                            const SizedBox(height: 20),

                            // Icon section
                            _buildIconSection(
                              ctx: ctx,
                              category: category,
                              selectedImageBytes: selectedImageBytes,
                              selectedImageName: selectedImageName,
                              isUploading: isUploading,
                              onImageSelected: (bytes, name) {
                                setState(() {
                                  selectedImageBytes = bytes;
                                  selectedImageName = name;
                                });
                                checkForChanges(setState);
                              },
                              onImageRemoved: () {
                                setState(() {
                                  selectedImageBytes = null;
                                  selectedImageName = null;
                                });
                                checkForChanges(setState);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Footer ───────────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FC),
                        border: Border(
                          top: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isUploading
                                  ? null
                                  : () => Navigator.of(ctx).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cancel',
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
                              onPressed: canSave
                                  ? () async {
                                      if (titleEnController.text
                                              .trim()
                                              .isEmpty ||
                                          promptController.text
                                              .trim()
                                              .isEmpty) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  CupertinoIcons
                                                      .exclamationmark_circle,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Please fill all required fields.",
                                                ),
                                              ],
                                            ),
                                            backgroundColor:
                                                Colors.red.shade600,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.all(16),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() => isUploading = true);
                                      try {
                                        Navigator.of(ctx).pop();
                                        await onTap(
                                          titleEn: titleEnController.text
                                              .trim(),
                                          prompt: promptController.text.trim(),
                                          categoryId: category?.id,
                                          iconFile: selectedImageBytes,
                                          iconFileName: selectedImageName,
                                        );
                                      } catch (_) {
                                        setState(() => isUploading = false);
                                      }
                                    }
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF97316),
                                disabledBackgroundColor: Colors.grey.shade200,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isUploading
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('Processing...'),
                                      ],
                                    )
                                  : Text(
                                      isEdit ? 'Update' : 'Create',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: canSave
                                            ? Colors.white
                                            : Colors.grey.shade400,
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
          },
        );
      },
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    IconData? icon,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        prefixIcon: icon != null
            ? Icon(icon, size: 16, color: Colors.grey.shade400)
            : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF97316), width: 1.5),
        ),
      ),
    );
  }

  static Widget _buildIconSection({
    required BuildContext ctx,
    required CategoryModel? category,
    required Uint8List? selectedImageBytes,
    required String? selectedImageName,
    required bool isUploading,
    required void Function(Uint8List bytes, String name) onImageSelected,
    required VoidCallback onImageRemoved,
  }) {
    final hasNew = selectedImageBytes != null;
    final hasExisting = _hasExistingIcon(category);

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  CupertinoIcons.photo,
                  size: 14,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Category icon',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Preview
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFEEF2FF),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasNew
                    ? Image.memory(selectedImageBytes!, fit: BoxFit.cover)
                    : hasExisting
                    ? NetworkImageLoader(
                        url: _getIconUrl(category!),
                        width: 72,
                        height: 72,
                      )
                    : Icon(
                        CupertinoIcons.photo,
                        size: 30,
                        color: Colors.grey.shade400,
                      ),
              ),
              const SizedBox(width: 16),

              // Controls
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasNew) ...[
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              selectedImageName ?? 'Selected image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ] else if (hasExisting) ...[
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            size: 14,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Current icon',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: isUploading
                              ? null
                              : () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                        type: FileType.image,
                                        withData: true,
                                      );
                                  if (result != null &&
                                      result.files.single.bytes != null) {
                                    onImageSelected(
                                      result.files.single.bytes!,
                                      result.files.single.name,
                                    );
                                  }
                                },
                          icon: const Icon(Icons.upload, size: 14),
                          label: Text(
                            hasNew || hasExisting
                                ? 'Change icon'
                                : 'Upload icon',
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF97316),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (hasNew) ...[
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: onImageRemoved,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              side: BorderSide(color: Colors.red.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Remove image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
