import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/service/review_service.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';

abstract class ReviewServiceRemoteDataSource {
  Future<ReviewService?> add({required ReviewService review});
  Future<void> update({required ReviewService review});
  Future<void> delete({required ReviewService review});

  Future<List<ReviewService>> getAll();
  Future<List<ReviewService>> getAllByUserId({required String userId});
  Future<List<ReviewService>> getAllByServiceId({
    required String serviceId,
    DateTime? lastCreateAt,
    int? limit,
  });

  Future<ReviewService?> getMyReviewInService(
      {required String userId, required String serviceId});
}

class ReviewServiceRemoteDataSourceImpl
    implements ReviewServiceRemoteDataSource {
  final db = sl.get<FirebaseFirestore>();

  late final colection = db.collectionGroup('reviews');
  @override
  Future<ReviewService?> add({required ReviewService review}) async {
    try {
      final serviceId = review.serviceId;
      if (serviceId == null) {
        throw Exception('Lỗi thực hiện');
      }
      // transaction update rating, ratingCount and add review
      final response = await db.runTransaction((transaction) async {
        final serviceRef = db.collection('services').doc(serviceId);
        final serviceDoc = await transaction.get(serviceRef);
        if (!serviceDoc.exists) {
          throw Exception('Dịch vụ không tồn tại');
        }

        final reviewRef = serviceRef.collection('reviews').doc();
        final reviewData = review.toJson();
        reviewData['id'] = reviewRef.id;
        reviewData['createdAt'] = FieldValue.serverTimestamp();
        transaction.set(reviewRef, reviewData);

        // update rating and ratingCount service
        final numStar = review.rating?.toInt();
        transaction.update(serviceRef, {
          'ratingCount.$numStar': FieldValue.increment(1),
        });
        return review.copyWith(id: reviewRef.id);
      });
      return response;
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required ReviewService review}) async {
    try {
      if (review.id == null || review.serviceId == null) {
        throw Exception('Đánh giá không tồn tại hoặc không tim thấy');
      }
      final respone = await db.runTransaction((transaction) async {
        final serviceRef = db.collection('services').doc(review.serviceId);
        final reviewRef = serviceRef.collection('reviews').doc(review.id);
        final reviewOld = await transaction.get(reviewRef);
        final serviceOld = await transaction.get(serviceRef);
        transaction.update(reviewRef, {
          'comment': review.comment,
          'rating': review.rating,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        final data = reviewOld.data()!;
        final oldRating = data['rating'].toInt();
        final newRating = review.rating?.toInt();
        final serviceOldRatingCount =
            serviceOld.data()!['ratingCount']?['$oldRating'] ?? 0;

        if (serviceOldRatingCount > 0) {
          transaction.update(serviceRef, {
            'ratingCount.$newRating': FieldValue.increment(1),
            'ratingCount.$oldRating': FieldValue.increment(-1),
          });
        } else {
          transaction.update(serviceRef, {
            'ratingCount.$newRating': FieldValue.increment(1),
            'ratingCount.$oldRating': 0,
          });
        }
      });
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required ReviewService review}) async {
    try {
      if (review.id == null || review.serviceId == null) {
        throw Exception('Lỗi thực hiện');
      }
      final refReview =
          db.doc('services/${review.serviceId}/reviews/${review.id}');
      await refReview.delete();
      final rating = review.rating?.toInt();
      final refService = db.doc('services/${review.serviceId}');
      refService.update({
        'ratingCount.$rating': FieldValue.increment(-1),
      });
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ReviewService>> getAll() async {
    try {
      final response = await colection.get();
      return response.docs.map((e) {
        return ReviewService.fromDocumentSnapshot(e);
      }).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ReviewService>> getAllByServiceId({
    required String serviceId,
    DateTime? lastCreateAt,
    int? limit,
  }) async {
    try {
      final colectRef = db.collection('services/$serviceId/reviews');
      Query query = colectRef.orderBy('createdAt', descending: true);
      if (lastCreateAt != null) {
        query = query.startAfter([lastCreateAt]);
      }
      final response = await query.limit(limit ?? LIMIT_PAGE).get();
      final data = response.docs
          .map((e) => ReviewService.fromDocumentSnapshot(e))
          .toList();
      return data;
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ReviewService>> getAllByUserId({required String userId}) async {
    try {
      final response = await colection.where('userId', isEqualTo: userId).get();
      return response.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        return ReviewService.fromJson(data).copyWith(id: e.id);
      }).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<ReviewService?> getMyReviewInService(
      {required String userId, required String serviceId}) async {
    try {
      final reviewRef = db.collection('services/$serviceId/reviews');
      final response = await reviewRef.where('userId', isEqualTo: userId).get();
      if (response.docs.isEmpty) {
        return null;
      }
      return ReviewService.fromDocumentSnapshot(response.docs.first);
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
