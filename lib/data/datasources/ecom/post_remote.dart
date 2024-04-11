import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/utils/utils.dart';

abstract class PostRemoteDataSource {
  Future<String?> add({required PostModel post});
  Future<void> update({required PostModel post});
  Future<void> delete({required String id});
  Future<List<PostModel>> getAll();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final CollectionReference colection =
      FirebaseFirestore.instance.collection('posts');
  @override
  Future<String?> add({required PostModel post}) async {
    try {
      final response = await colection.add(post.toJson());
      return response.id;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required PostModel post}) async {
    try {
      await colection.doc(post.id).update(post.toJson());
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await colection.doc(id).delete();
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getAll() async {
    try {
      final response =
          await colection.orderBy('createdAt', descending: true).get();
      return response.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        switch (data['type']) {
          case 'news':
            return NewsModel.fromDocumentSnapshot(e);
          case 'event':
            return EventModel.fromDocumentSnapshot(e);
          default:
            return PostModel.fromDocumentSnapshot(e);
        }
      }).toList();
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
