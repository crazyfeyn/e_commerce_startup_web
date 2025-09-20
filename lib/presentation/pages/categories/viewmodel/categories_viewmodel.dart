import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';
import 'package:e_commerce_startup_web/data/repositories/category_repository_impl.dart';
import 'package:flutter/material.dart';

class CategoriesViewmodel extends ChangeNotifier {
  final _repository = CategoryRepositoryImpl();

  CategoriesViewmodel() {
    fetchCategories();
  }

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.inProgress;
  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    final result = await _repository.fetchCategories();
    if(result.isRight()) {
      categories = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();

    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createCategory({required String uzTitle, required String enTitle, required String koTitle, required String prompt, int? categoryId}) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final title = {"uz": uzTitle, "en": enTitle, "kor": koTitle};
    final result = await _repository.createCategory(title, prompt);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchCategories();
      formzStatus = FormzSubmissionStatus.canceled;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> editCategory({int? categoryId, required String uzTitle, required String enTitle, required String koTitle, required String prompt}) async {
    if(categoryId == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final title = {"uz": uzTitle, "en": enTitle, "kor": koTitle};
    final result = await _repository.editCategory(categoryId, title, prompt);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchCategories();
      formzStatus = FormzSubmissionStatus.canceled;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int? categoryId) async {
    if(categoryId == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.deleteCategory(categoryId);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchCategories();
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