import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/viewmodel/categories_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/widget/category_dialog.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  static const String path = "/categories";

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoriesViewmodel(),
      child: Consumer<CategoriesViewmodel>(
        builder: (_, viewmodel, __) {
          return Scaffold(
            appBar: AppBar(title: Text(context.tr(LocaleKeys.menu_categories))),
            body: viewmodel.formzStatus.isInProgress
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(context.tr(LocaleKeys.id))),
                          DataColumn(label: Text(context.tr(LocaleKeys.icon))),
                          DataColumn(
                            label: Text(
                              context.tr(LocaleKeys.category_name_uz_title),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              context.tr(LocaleKeys.category_name_kr_title),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              context.tr(LocaleKeys.category_name_en_title),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              context.tr(LocaleKeys.category_prompt_title),
                            ),
                          ),
                          DataColumn(
                            label: Text(context.tr(LocaleKeys.actions)),
                          ),
                        ],
                        rows: List.generate(viewmodel.categories.length, (
                          index,
                        ) {
                          final category = viewmodel.categories[index];
                          return DataRow(
                            cells: [
                              DataCell(Text(category.id?.toString() ?? "")),
                              DataCell(
                                _buildCategoryIcon(
                                  category.imageIdentity ?? '',
                                ),
                              ),
                              DataCell(Text(category.titleData?.uz ?? "")),
                              DataCell(Text(category.titleData?.kor ?? "")),
                              DataCell(Text(category.titleData?.en ?? "")),
                              DataCell(
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Text(
                                    category.description ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        CategoryDialog.categoryShowDialog(
                                          context: context,
                                          category: category,
                                          onTap:
                                              ({
                                                required String uzTitle,
                                                required String enTitle,
                                                required String koTitle,
                                                required String prompt,
                                                int? categoryId,
                                                iconFile,
                                                iconFileName,
                                              }) => viewmodel.editCategory(
                                                categoryId: categoryId,
                                                uzTitle: uzTitle,
                                                enTitle: enTitle,
                                                koTitle: koTitle,
                                                prompt: prompt,
                                                iconFile: iconFile,
                                                iconFileName: iconFileName,
                                              ),
                                        );
                                      },
                                      icon: Icon(
                                        CupertinoIcons.pencil,
                                        size: 16,
                                        color: AppColors.warning400,
                                      ),
                                      tooltip: context.tr(
                                        LocaleKeys.edit_category,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _showDeleteConfirmation(
                                        context,
                                        category,
                                        viewmodel,
                                      ),
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        size: 16,
                                        color: AppColors.red500,
                                      ),
                                      tooltip: context.tr(
                                        LocaleKeys.delete_category,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                CategoryDialog.categoryShowDialog(
                  context: context,
                  onTap:
                      ({
                        required String uzTitle,
                        required String enTitle,
                        required String koTitle,
                        required String prompt,
                        int? categoryId,
                        iconFile,
                        iconFileName,
                      }) => viewmodel.createCategory(
                        uzTitle: uzTitle,
                        enTitle: enTitle,
                        koTitle: koTitle,
                        prompt: prompt,
                        iconFile: iconFile,
                        iconFileName: iconFileName,
                      ),
                );
              },
              tooltip: context.tr(LocaleKeys.add_new_category),
              child: const Icon(Icons.add, size: 32),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(String? imageIdentity) {
    if (imageIdentity == null || imageIdentity.isEmpty) {
      return _buildPlaceholderIcon();
    }

    final imageUrl =
        "${NetworkService.getService}${NetworkService.apiFileDownload(imageIdentity)}";

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: NetworkImageLoader(url: imageUrl, width: 40, height: 40),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(CupertinoIcons.photo, size: 20, color: Colors.grey.shade500),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    dynamic category,
    CategoriesViewmodel viewmodel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr(LocaleKeys.delete_category_title)),
          content: Text(
            context.tr(
              LocaleKeys.delete_category_message,
              args: [
                category.titleData?.en ??
                    category.titleData?.uz ??
                    context.tr(LocaleKeys.category_name_en_title),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.tr(LocaleKeys.cancel)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewmodel.deleteCategory(category.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red500,
                foregroundColor: Colors.white,
              ),
              child: Text(context.tr(LocaleKeys.delete)),
            ),
          ],
        );
      },
    );
  }
}
