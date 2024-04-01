import 'dart:io';

abstract class FileRepository {
  Future<String> uploadFile(
      {required File file,
      required String path,
      String contentType = 'image/jpeg',
      Function(int)? onProgress});
  Future<void> deleteFile({required String path});
}
