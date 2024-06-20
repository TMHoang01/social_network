import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/joiners.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/utils/utils.dart';

abstract class PostRemoteDataSource {
  Future<String?> add({required PostModel post});
  Future<void> update({required PostModel post});
  Future<void> delete({required String id});
  Future<List<PostModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});
  Future<List<PostModel>> paginateQuey(
      {int limit = 20, String? query, String? type, DateTime? lastUpdate});

  Future<void> joinEvent({required String id, required JoinersModel joiner});

  Future<void> leaveEvent({required String id, required String userId});

  Future<PostModel> get({required String id});
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
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<PostModel> get({required String id}) async {
    try {
      final response = await colection.doc(id).get();
      final data = response.data() as Map<String, dynamic>;
      switch (data['type']) {
        case 'news':
          return NewsModel.fromDocumentSnapshot(response);
        case 'event':
          return EventModel.fromDocumentSnapshot(response);
        default:
          return PostModel.fromDocumentSnapshot(response);
      }
    } on FirebaseException catch (e) {
      logger.e(e.toString());
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
  Future<List<PostModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    try {
      Query query = colection.orderBy('createdAt', descending: true);

      if (lastCreateAt != null) {
        query = query.startAfter([lastCreateAt]);
      }
      if (filter != null) {
        filter.forEach((key, value) {
          query = query.where(key, isEqualTo: value);
        });
      }
      query = query.limit(limit);
      final response = await query.get();

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

  @override
  Future<List<PostModel>> paginateQuey(
      {int limit = LIMIT_PAGE,
      String? query,
      String? type,
      DateTime? lastUpdate}) async {
    try {
      Query queryRef = colection;
      if (query != null && query.isNotEmpty) {
        queryRef = queryRef.where('title', isGreaterThanOrEqualTo: query);
      }
      if (type != null && type.isNotEmpty) {
        queryRef = queryRef.where('type', isEqualTo: type);
      }
      queryRef = colection.orderBy('createdAt', descending: true);
      if (lastUpdate != null) {
        queryRef = queryRef.startAfter([lastUpdate]);
      }
      queryRef = queryRef.limit(limit);
      final response = await queryRef.get();
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

  @override
  Future<void> joinEvent(
      {required String id, required JoinersModel joiner}) async {
    try {
      final postRef = colection.doc(id);
      final querySnapshot = await postRef
          .collection('joiners')
          .where('id', isEqualTo: joiner.id)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Người dùng đã đăng ký tham gia sự kiện này rồi!');
      }
      final joiners = postRef.collection('joiners').doc();

      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot postSnapshot = await transaction.get(postRef);
        final event = EventModel.fromDocumentSnapshot(postSnapshot);
        final joinersCount = event.joinersCount ?? 0 + 1;
        // Update array joinerIds
        final joinerIds = event.joinerIds ?? [];
        joinerIds.add(joiner.id);
        transaction.update(
            postRef, {'joinerIds': joinerIds, 'joinersCount': joinersCount});
        transaction.set(joiners, joiner.toJson());
      });
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> leaveEvent({required String id, required String userId}) async {
    try {
      final postRef = colection.doc(id);
      final querySnapshot = await postRef
          .collection('joiners')
          .where('id', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Người dùng chưa đăng ký tham gia sự kiện này!');
      }
      final joiners = querySnapshot.docs.first.reference;
      await firestore.runTransaction((transaction) async {
        final DocumentSnapshot postSnapshot = await transaction.get(postRef);
        final event = EventModel.fromDocumentSnapshot(postSnapshot);
        final joinersCount = event.joinersCount ?? 0 - 1;
        // Update array joinerIds
        final joinerIds = event.joinerIds ?? [];
        joinerIds.remove(userId);
        transaction.update(
            postRef, {'joinerIds': joinerIds, 'joinersCount': joinersCount});
        transaction.delete(joiners);
      });
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
