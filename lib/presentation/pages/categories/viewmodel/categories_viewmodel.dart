import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/data/repositories/category_repository_impl.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class CategoriesViewmodel extends ChangeNotifier {
  final _repository = CategoryRepositoryImpl();

  CategoriesViewmodel() {
    fetchCategories();
  }

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.inProgress;
  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    final result = await _repository.fetchCategories();
    if (result.isRight()) {
      categories = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  // NEW: Create category with only English title + prompt
  Future<void> createCategory({
    required String titleEn,
    required String prompt,
    Uint8List? iconFile,
    String? iconFileName,
  }) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    try {
      // Send only English title (backend will auto-translate via Anthropic)
      final titleData = {"en": titleEn};

      final createResult = await _repository.createCategory(titleData, prompt);

      if (createResult.isRight()) {
        final createdCategoryId = createResult.getOrElse(
          () => throw Exception("Unexpected error"),
        );

        if (createdCategoryId != null) {
          if (iconFile != null && iconFileName != null) {
            await _repository.uploadIcon(
              categoryId: createdCategoryId,
              iconFile: iconFile,
              fileName: iconFileName,
            );
          }
          await fetchCategories();
          return;
        }

        formzStatus = FormzSubmissionStatus.canceled;
        notifyListeners();
      } else {
        formzStatus = FormzSubmissionStatus.failure;
        notifyListeners();
      }
    } catch (e) {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  // NEW: Edit category with only English title + prompt
  Future<void> editCategory({
    int? categoryId,
    required String titleEn,
    required String prompt,
    Uint8List? iconFile,
    String? iconFileName,
  }) async {
    if (categoryId == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    try {
      // Send only English title (backend will re-translate via Anthropic)
      final titleData = {"en": titleEn};

      final editResult = await _repository.editCategory(
        categoryId,
        titleData,
        prompt,
      );

      if (editResult.isRight()) {
        final success = editResult.getOrElse(
          () => throw Exception("Unexpected error"),
        );

        if (success) {
          if (iconFile != null && iconFileName != null) {
            await _repository.uploadIcon(
              categoryId: categoryId,
              iconFile: iconFile,
              fileName: iconFileName,
            );
          }
          await fetchCategories();
          return;
        }

        formzStatus = FormzSubmissionStatus.canceled;
        notifyListeners();
      } else {
        formzStatus = FormzSubmissionStatus.failure;
        notifyListeners();
      }
    } catch (e) {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int? categoryId) async {
    if (categoryId == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.deleteCategory(categoryId);
    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if (res) return await fetchCategories();
      formzStatus = FormzSubmissionStatus.canceled;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
