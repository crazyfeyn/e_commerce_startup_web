import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/viewmodel/categories_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/widget/category_dialog.dart';
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
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(context.tr(LocaleKeys.id))),
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
                          DataColumn(label: Text("")),
                        ],
                        rows: List.generate(viewmodel.categories.length, (
                          index,
                        ) {
                          final category = viewmodel.categories[index];
                          return DataRow(
                            cells: [
                              DataCell(Text(category.id?.toString() ?? "")),
                              DataCell(Text(category.titleData?.uz ?? "")),
                              DataCell(Text(category.titleData?.kor ?? "")),
                              DataCell(Text(category.titleData?.en ?? "")),
                              DataCell(Text(category.description ?? "")),
                              DataCell(
                                showEditIcon: true,
                                onTap: () {
                                  CategoryDialog.categoryShowDialog(
                                    context: context,
                                    category: category,
                                    onTap: viewmodel.editCategory,
                                  );
                                },
                                IconButton(
                                  onPressed: () => viewmodel.deleteCategory(category.id),
                                  icon: Icon(
                                    CupertinoIcons.delete,
                                    size: 16,
                                    color: AppColors.red500,
                                  ),
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
                  onTap: viewmodel.createCategory,
                );
              },
              child: Icon(Icons.add, size: 32),
            ),
          );
        },
      ),
    );
  }
}
