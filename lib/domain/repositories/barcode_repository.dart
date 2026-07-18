import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/data/models/barcode_product_model.dart';

abstract class BarcodeRepository {
  Future<Either<String, int?>> createBarcodeProduct({
    required String barcode,
    required String nameEn,
    required List<String> ingredients,
    required bool isHalal,
  });

  Future<Either<String, BarcodeProductModel>> lookupBarcodeProduct(String code);

  void dispose();
}
