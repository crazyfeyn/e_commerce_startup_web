import 'dart:typed_data';

class UploadImageModel {
  final Uint8List file;
  final String name;

  UploadImageModel(this.file, this.name);
}