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
    if(result.isRight()) {
      products = result.getOrElse(() => throw Exception("Unexpected error"));
      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();

    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> createProduct(ProductModel product) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.createProduct(product);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchProducts();
      formzStatus = FormzSubmissionStatus.canceled;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> editProduct(List<UploadImageModel> files, ProductModel product) async {
    if(product.id == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    if(files.isNotEmpty) await uploadImages(product.id!, files);
    final result = await _repository.editProduct(product);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchProducts();
      formzStatus = FormzSubmissionStatus.canceled;
      notifyListeners();
    } else {
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<void> uploadImages(int productId, List<UploadImageModel> files) async {
    final result = await _repository.uploadImage(productId, files);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));
      debugPrint("RESPONCE: $res");
    }
  }

  Future<void> deleteProduct(int? productid) async {
    if(productid == null) return;

    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.deleteProduct(productid);
    if(result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));

      if(res) return await fetchProducts();
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