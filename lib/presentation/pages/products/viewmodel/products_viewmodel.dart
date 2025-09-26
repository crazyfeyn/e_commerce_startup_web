import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';
import 'package:e_commerce_startup_web/data/models/upload_image_model.dart';
import 'package:e_commerce_startup_web/data/repositories/product_repository_impl.dart';
import 'package:flutter/material.dart';

class ProductsViewmodel extends ChangeNotifier {
  final _repository = ProductRepositoryImpl();

  ProductsViewmodel() {
    fetchProducts();
  }

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.inProgress;
  List<ProductModel> products = [];

  Future<void> fetchProducts() async {
    final result = await _repository.fetchProducts();
    if (result.isRight()) {
      products = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createProduct(
    ProductModel product,
    List<UploadImageModel> images,
  ) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final createResult = await _repository.createProduct(product);
    if (createResult.isRight()) {
      final productId = createResult.getOrElse(
        () => throw Exception("Unexpected error"),
      );

      if (images.isNotEmpty) {
        final uploadResult = await _repository.uploadImage(productId, images);
        if (uploadResult.isLeft()) {
          formzStatus = FormzSubmissionStatus.failure;
          notifyListeners();
          await fetchProducts();
          return;
        }
      }
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();
      await fetchProducts();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> editProduct(
    List<UploadImageModel> files,
    ProductModel product,
  ) async {
    if (product.id == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();
    if (files.isNotEmpty) {
      final uploadResult = await uploadImages(product.id!, files);
      if (!uploadResult) {
        formzStatus = FormzSubmissionStatus.failure;
        notifyListeners();
        return;
      }
    }

    final result = await _repository.editProduct(product);
    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if (res) {
        formzStatus = FormzSubmissionStatus.success;
        notifyListeners();
        await fetchProducts();
      } else {
        formzStatus = FormzSubmissionStatus.canceled;
        notifyListeners();
      }
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<bool> uploadImages(int productId, List<UploadImageModel> files) async {
    final result = await _repository.uploadImage(productId, files);
    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));
      debugPrint("RESPONSE: $res");
      return true;
    }
    return false;
  }

  Future<void> deleteProduct(int? productid) async {
    if (productid == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.deleteProduct(productid);
    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if (res) {
        formzStatus = FormzSubmissionStatus.success;
        notifyListeners();
        await fetchProducts();
      } else {
        formzStatus = FormzSubmissionStatus.canceled;
        notifyListeners();
      }
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
