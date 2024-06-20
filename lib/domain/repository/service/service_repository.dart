import 'package:social_network/data/datasources/service/service_remote.dart';
import 'package:social_network/domain/models/service/service.dart';

abstract class ServiceRepository {
  // CRUD service
  Future<ServiceModel> add({required ServiceModel service});
  Future<void> update({required ServiceModel service});
  Future<void> delete({required String id});
  Stream<List<ServiceModel>> getAll();

  Stream<List<ServiceModel>> getAllByProvider({required String userId});
}

class ServiceRepositoryImpl extends ServiceRepository {
  final ServiceRemoteDataSource serviceRemoteDataSource;

  ServiceRepositoryImpl(this.serviceRemoteDataSource);

  @override
  Future<ServiceModel> add({required ServiceModel service}) async {
    return service.copyWith(
        id: await serviceRemoteDataSource.add(service: service));
  }

  @override
  Future<void> update({required ServiceModel service}) async {
    return serviceRemoteDataSource.update(service: service);
  }

  @override
  Future<void> delete({required String id}) async {
    return serviceRemoteDataSource.delete(id: id);
  }

  @override
  Stream<List<ServiceModel>> getAll() async* {
    yield* serviceRemoteDataSource.getAll();
  }

  @override
  Stream<List<ServiceModel>> getAllByProvider({required String userId}) async* {
    yield* serviceRemoteDataSource.getAllByProvider(userId: userId);
  }
}
