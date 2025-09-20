import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<String, List<CategoryModel>>> fetchCategories();

  Future<Either<String, bool>> createCategory(Map<String, dynamic> title, String prompt);

  Future<Either<String, bool>> editCategory(int categoryId, Map<String, dynamic> title, String prompt);

  Future<Either<String, bool>> deleteCategory(int categoryId);

  void dispose();
}