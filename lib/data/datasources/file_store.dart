import 'dart:async';
import 'dart:io';

import 'package:social_network/domain/repository/file_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/logger.dart';

class FileStoreIml extends FileRepository {
  final storageRef = sl.call<FirebaseStorage>().ref();

  @override
  Future<void> deleteFile({required String path}) async {
    try {
      FirebaseStorage.instance.refFromURL(path).delete();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
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
