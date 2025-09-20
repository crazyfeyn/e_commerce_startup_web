import 'package:dartz/dartz.dart';
import 'package:e_commerce_startup_web/data/models/measurement_model.dart';
import 'package:e_commerce_startup_web/data/models/product_model.dart';
import 'package:e_commerce_startup_web/data/models/upload_image_model.dart';

abstract class ProductRepository {
  Future<Either<String, List<ProductModel>>> fetchProducts();

  Future<Either<String, List<MeasurementModel>>> fetchMeasurements();

  Future<Either<String, bool>> createProduct(ProductModel product);

  Future<Either<String, bool>> editProduct(ProductModel product);

  Future<Either<String, bool>> deleteProduct(int productId);

  Future<Either<String, bool>> uploadImage(int productId, List<UploadImageModel> files);

  void dispose();
}