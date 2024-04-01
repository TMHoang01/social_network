import 'dart:async';
import 'dart:io';

import 'package:social_network/domain/repository/file_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_network/utils/logger.dart';

class FileRepositoryIml extends FileRepository {
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<void> deleteFile({required String path}) {
    return storageRef.child(path).delete();
  }

  @override
  Future<String> uploadFile({
    required File file,
    required String path,
    String contentType = 'image/jpeg',
    Function(int)? onProgress,
  }) async {
    try {
      final ref = storageRef.child(path);
      final uploadTask =
          ref.putFile(file, SettableMetadata(contentType: contentType));
      final snapshot = await uploadTask.whenComplete(() {});
      uploadTask.snapshotEvents.listen((TaskSnapshot event) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        final percentage = (progress * 100).toInt();
        logger.w('Uploading file image: $percentage');
        onProgress?.call(percentage);
      })
        ..onError((error) {
          logger.e(error);
          throw Exception(error.toString());
        })
        ..onDone(() {});

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
