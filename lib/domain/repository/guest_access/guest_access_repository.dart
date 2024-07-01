import 'package:social_network/data/datasources/guest_access/guest_access_remote.dart';
import 'package:social_network/domain/models/guest_access/guest_access.dart';
import 'package:social_network/utils/utils.dart';

abstract class GuestAccessRepository {
  Future<GuestAccess?> add(GuestAccess guestAccess);
  Future<GuestAccess?> getById(String id);
  Future<void> update(GuestAccess guestAccess);
  Future<void> delete(String id);

  Future<List<GuestAccess>> getByDate(DateTime time);
  Future<List<GuestAccess>> getAllByUserId(String userId);
}

class GuestAccessRepositoryImpl implements GuestAccessRepository {
  final GuestAccessRemoteDataSource remoteDate;

  GuestAccessRepositoryImpl(this.remoteDate);

  @override
  Future<GuestAccess?> add(GuestAccess guestAccess) async {
    return await remoteDate.add(guestAccess);
  }

  @override
  Future<GuestAccess?> getById(String id) async {
    final guestAccessLocal = GuestAccess();
    if (guestAccessLocal.id != null) {
      return guestAccessLocal;
    } else {
      logger.i('get guestAccess from remote');
    }
  }

  @override
  Future<void> delete(String id) async {
    return await remoteDate.delete(id);
  }

  @override
  Future<List<GuestAccess>> getByDate(DateTime time) async {
    return await remoteDate.getByDate(time);
  }

  @override
  Future<void> update(GuestAccess guestAccess) async {
    return await remoteDate.update(guestAccess);
  }

  @override
  Future<List<GuestAccess>> getAllByUserId(String userId) async {
    return await remoteDate.getAllByUserId(userId);
  }
}
