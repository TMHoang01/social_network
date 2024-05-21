import 'package:social_network/data/datasources/service/review_service_remote.dart';
import 'package:social_network/domain/models/service/review_service.dart';

abstract class ReviewRepository {
  Future<ReviewService?> add({required ReviewService review});
  Future<List<ReviewService>> getAll();
  Future<List<ReviewService>> getAllByUserId({required String userId});
  Future<List<ReviewService>> getAllByServiceId(
      {required String serviceId, DateTime? lastCreateAt, int? limit});
  Future<void> delete({required ReviewService review});
  Future<void> update({required ReviewService review});

  Future<ReviewService?> getMyReviewInService(
      {required String userId, required String serviceId});
}

class ReviewRepositoryIml implements ReviewRepository {
  final ReviewServiceRemoteDataSource remoteData;

  ReviewRepositoryIml(this.remoteData);

  @override
  Future<ReviewService?> add({required ReviewService review}) async {
    return await remoteData.add(review: review);
  }

  @override
  Future<void> delete({required ReviewService review}) async {
    return await remoteData.delete(review: review);
  }

  @override
  Future<List<ReviewService>> getAll() {
    return remoteData.getAll();
  }

  @override
  Future<List<ReviewService>> getAllByServiceId(
      {required String serviceId, DateTime? lastCreateAt, int? limit}) async {
    return await remoteData.getAllByServiceId(
        serviceId: serviceId, lastCreateAt: lastCreateAt, limit: limit);
  }

  @override
  Future<List<ReviewService>> getAllByUserId({required String userId}) async {
    // TODO: implement getAllByUserId
    throw UnimplementedError();
  }

  @override
  Future<void> update({required ReviewService review}) async {
    return await remoteData.update(review: review);
  }

  @override
  Future<ReviewService?> getMyReviewInService(
      {required String userId, required String serviceId}) async {
    return await remoteData.getMyReviewInService(
        userId: userId, serviceId: serviceId);
  }
}
