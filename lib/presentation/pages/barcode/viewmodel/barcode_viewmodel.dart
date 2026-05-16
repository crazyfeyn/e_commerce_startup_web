import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/data/models/barcode_product_model.dart';
import 'package:e_commerce_startup_web/data/repositories/barcode_repository_impl.dart';
import 'package:flutter/material.dart';

class BarcodeViewmodel extends ChangeNotifier {
  final _repository = BarcodeRepositoryImpl();

  FormzSubmissionStatus formzStatus = FormzSubmissionStatus.initial;
  FormzSubmissionStatus lookupStatus = FormzSubmissionStatus.initial;

  BarcodeProductModel? lookedUpProduct;

  // ── Create ─────────────────────────────────────────────────────────────────
  Future<void> createBarcodeProduct({
    required String barcode,
    required String nameEn,
    required List<String> ingredients,
    required bool isHalal,
  }) async {
    formzStatus = FormzSubmissionStatus.inProgress;
    notifyListeners();

    final result = await _repository.createBarcodeProduct(
      barcode: barcode,
      nameEn: nameEn,
      ingredients: ingredients,
      isHalal: isHalal,
    );

    if (result.isRight()) {
      formzStatus = FormzSubmissionStatus.success;
    } else {
      formzStatus = FormzSubmissionStatus.failure;
    }
    notifyListeners();
  }

  // ── Lookup ─────────────────────────────────────────────────────────────────
  Future<void> lookupBarcodeProduct(String code) async {
    lookupStatus = FormzSubmissionStatus.inProgress;
    lookedUpProduct = null;
    notifyListeners();

    final result = await _repository.lookupBarcodeProduct(code);

    result.fold(
      (_) {
        lookupStatus = FormzSubmissionStatus.failure;
        notifyListeners();
      },
      (product) {
        lookedUpProduct = product;
        lookupStatus = FormzSubmissionStatus.success;
        notifyListeners();
      },
    );
  }

  void resetLookup() {
    lookedUpProduct = null;
    lookupStatus = FormzSubmissionStatus.initial;
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
