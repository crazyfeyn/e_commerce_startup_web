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

// Flex weights: ID | Icon | UZ | KR | EN | Prompt | Actions
const List<int> _flex = [
  1,
  1,
  2,
  2,
  2,
  2,
  2,
]; // increased actions flex, decreased prompt

class CategoriesPage extends StatelessWidget {
  static const String path = "/categories";

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoriesViewmodel(),
      child: Consumer<CategoriesViewmodel>(
        builder: (_, viewmodel, __) => Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          appBar: _buildAppBar(context, viewmodel),
          body: viewmodel.formzStatus.isInProgress
              ? _buildLoading()
              : viewmodel.categories.isEmpty
              ? _buildEmpty(context)
              : _buildTable(context, viewmodel),
          floatingActionButton: _buildFab(context, viewmodel),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CategoriesViewmodel viewmodel,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE5E7EB)),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              CupertinoIcons.square_grid_2x2,
              size: 18,
              color: const Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr(LocaleKeys.menu_categories),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          if (!viewmodel.formzStatus.isInProgress &&
              viewmodel.categories.isNotEmpty) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${viewmodel.categories.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading categories...',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              CupertinoIcons.square_grid_2x2,
              size: 44,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr(LocaleKeys.menu_categories),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No categories yet. Tap + to add one.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, CategoriesViewmodel viewmodel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _buildHeaderRow(context),
              Expanded(
                child: ListView.builder(
                  itemCount: viewmodel.categories.length,
                  itemBuilder: (context, i) =>
                      _buildDataRow(context, viewmodel, i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final labels = [
      context.tr(LocaleKeys.id),
      context.tr(LocaleKeys.icon),
      context.tr(LocaleKeys.category_name_uz_title),
      context.tr(LocaleKeys.category_name_kr_title),
      context.tr(LocaleKeys.category_name_en_title),
      context.tr(LocaleKeys.category_prompt_title),
      context.tr(LocaleKeys.actions),
    ];

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => Expanded(
            flex: _flex[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                labels[i].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(
    BuildContext context,
    CategoriesViewmodel viewmodel,
    int index,
  ) {
    final category = viewmodel.categories[index];
    final bool isLast = index == viewmodel.categories.length - 1;

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          // ── ID ────────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[0],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "#${category.id ?? '-'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF97316),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Icon ──────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[1],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildCategoryIcon(category.imageIdentity ?? ''),
            ),
          ),

          // ── UZ ────────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[2],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildNameCell(category.titleData?.uz ?? ''),
            ),
          ),

          // ── KR ────────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[3],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildNameCell(category.titleData?.kor ?? ''),
            ),
          ),

          // ── EN ────────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[4],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildNameCell(category.titleData?.en ?? ''),
            ),
          ),

          // ── Prompt ────────────────────────────────────────────────────────
          Expanded(
            flex: _flex[5],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                category.description ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ── Actions ───────────────────────────────────────────────────────
          Expanded(
            flex: _flex[6],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionBtn(
                    onPressed: () => CategoryDialog.categoryShowDialog(
                      context: context,
                      category: category,
                      onTap:
                          ({
                            required uzTitle,
                            required enTitle,
                            required koTitle,
                            required prompt,
                            categoryId,
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
                    ),
                    icon: Icon(
                      CupertinoIcons.pencil,
                      size: 14,
                      color: Colors.orange.shade600,
                    ),
                    bg: Colors.orange.shade50,
                    tip: context.tr(LocaleKeys.edit_category),
                  ),
                  const SizedBox(width: 4),
                  _actionBtn(
                    onPressed: () =>
                        _showDeleteConfirmation(context, category, viewmodel),
                    icon: Icon(
                      CupertinoIcons.delete,
                      size: 14,
                      color: AppColors.red500,
                    ),
                    bg: Colors.red.shade50,
                    tip: context.tr(LocaleKeys.delete_category),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Removed flags, just show name with ellipsis
  Widget _buildNameCell(String name) {
    if (name.isEmpty) {
      return Text(
        '—',
        style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      name,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF374151),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCategoryIcon(String imageIdentity) {
    if (imageIdentity.isEmpty) return _buildPlaceholderIcon();

    final url =
        "${NetworkService.getService}${NetworkService.apiFileDownload(imageIdentity)}";

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: NetworkImageLoader(url: url, width: 40, height: 40),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Icon(CupertinoIcons.photo, size: 18, color: Colors.grey.shade400),
    );
  }

  Widget _actionBtn({
    required VoidCallback? onPressed,
    required Widget icon,
    required Color bg,
    required String tip,
  }) {
    return Tooltip(
      message: tip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 28, // reduced from 32
          height: 28, // reduced from 32
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, CategoriesViewmodel viewmodel) {
    return FloatingActionButton.extended(
      onPressed: () => CategoryDialog.categoryShowDialog(
        context: context,
        onTap:
            ({
              required uzTitle,
              required enTitle,
              required koTitle,
              required prompt,
              categoryId,
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
      ),
      backgroundColor: const Color(0xFFF97316),
      foregroundColor: Colors.white,
      elevation: 2,
      icon: const Icon(Icons.add, size: 20),
      label: Text(
        context.tr(LocaleKeys.add_new_category),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    dynamic category,
    CategoriesViewmodel viewmodel,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.delete,
                        color: AppColors.red500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        ctx.tr(LocaleKeys.delete_category_title),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  ctx.tr(
                    LocaleKeys.delete_category_message,
                    args: [
                      category.titleData?.en ??
                          category.titleData?.uz ??
                          ctx.tr(LocaleKeys.category_name_en_title),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          ctx.tr(LocaleKeys.cancel),
                          style: const TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          viewmodel.deleteCategory(category.id);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.red500,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          ctx.tr(LocaleKeys.delete),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
