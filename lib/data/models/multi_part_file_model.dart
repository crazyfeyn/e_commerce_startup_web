import 'dart:typed_data';

class MultipartFile {
  final Uint8List bytes;
  final String filename;
  final String? contentType;

  MultipartFile({
    required this.bytes,
    required this.filename,
    this.contentType,
  });
}
