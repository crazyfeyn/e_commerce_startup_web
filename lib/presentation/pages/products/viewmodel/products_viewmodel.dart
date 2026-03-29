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

    debugPrint("🚀 [createProduct] Starting product creation...");
    debugPrint("🚀 [createProduct] Product data: ${product.toCreate()}");
    debugPrint("🚀 [createProduct] Images count: ${images.length}");

    final createResult = await _repository.createProduct(product);

    if (createResult.isRight()) {
      final productId = createResult.getOrElse(
        () => throw Exception("Unexpected error"),
      );

      debugPrint("✅ [createProduct] Product created successfully!");
      debugPrint("✅ [createProduct] Returned productId: $productId");
      debugPrint("✅ [createProduct] productId type: ${productId.runtimeType}");

      if (images.isNotEmpty) {
        debugPrint(
          "📤 [createProduct] Uploading ${images.length} image(s) for productId: $productId",
        );

        final uploadResult = await _repository.uploadImage(productId, images);

        uploadResult.fold(
          (error) =>
              debugPrint("❌ [createProduct] Image upload FAILED: $error"),
          (success) =>
              debugPrint("✅ [createProduct] Image upload SUCCESS: $success"),
        );

        if (uploadResult.isLeft()) {
          formzStatus = FormzSubmissionStatus.failure;
          notifyListeners();
          await fetchProducts();
          return;
        }
      } else {
        debugPrint("⚠️ [createProduct] No images to upload, skipping.");
      }

      formzStatus = FormzSubmissionStatus.success;
      notifyListeners();
      await fetchProducts();
    } else {
      final error = createResult.fold((l) => l, (r) => "unknown");
      debugPrint("❌ [createProduct] Product creation FAILED: $error");
      formzStatus = FormzSubmissionStatus.failure;
      notifyListeners();
    }
  }

  Future<bool> uploadImages(int productId, List<UploadImageModel> files) async {
    debugPrint(
      "📤 [uploadImages] Uploading ${files.length} file(s) for productId: $productId",
    );

    for (int i = 0; i < files.length; i++) {
      final f = files[i];
      debugPrint("   📎 File[$i]: name=${f.name}, size=${f.file.length} bytes");
    }

    final result = await _repository.uploadImage(productId, files);

    result.fold(
      (error) => debugPrint("❌ [uploadImages] Upload FAILED: $error"),
      (success) => debugPrint("✅ [uploadImages] Upload SUCCESS: $success"),
    );

    if (result.isRight()) {
      final res = result.getOrElse(() => throw Exception("Unexpected error"));
      debugPrint("✅ [uploadImages] Server response: $res");
      return true;
    }
    return false;
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
