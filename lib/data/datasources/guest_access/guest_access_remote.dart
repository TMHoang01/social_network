import 'package:social_network/domain/models/guest_access/guest_access.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GuestAccessRemoteDataSource {
  Future<GuestAccess?> add(GuestAccess guestAccess);
  Future<GuestAccess?> getById(String id);
  Future<void> update(GuestAccess guestAccess);
  Future<void> delete(String id);

  Future<List<GuestAccess>> getByDate(DateTime time);

  Future<List<GuestAccess>> getAllByUserId(String userId);
}

class GuestAccessRemoteDataSourceImpl implements GuestAccessRemoteDataSource {
  final db = sl<FirebaseFirestore>();
  final guestAccessStr = 'guestAccess';

  @override
  Future<GuestAccess?> add(GuestAccess guestAccess) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = guestAccess.toJson();
      json['createdAt'] = createAt;
      json['createdBy'] = userCurrent?.uid;
      final response = await db.collection(guestAccessStr).add(json);
      return guestAccess.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete(String id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<GuestAccess>> getByDate(DateTime time) async {
    final timeBeginInDate = DateTime(time.year, time.month, time.day);
    final timeEndInDate = DateTime(time.year, time.month, time.day, 23, 59, 59);

    final snapshot = await db
        .collection(guestAccessStr)
        .where('expectedTime', isGreaterThanOrEqualTo: timeBeginInDate)
        .where('expectedTime', isLessThanOrEqualTo: timeEndInDate)
        .get();

    return snapshot.docs.map((e) {
      return GuestAccess.fromSnapshot(e);
    }).toList();
  }

  @override
  Future<GuestAccess?> getById(String id) async {}

  @override
  Future<void> update(GuestAccess guestAccess) async {}

  @override
  Future<List<GuestAccess>> getAllByUserId(String userId) async {
    final snapshot = await db
        .collection(guestAccessStr)
        .where('createdBy', isEqualTo: userId)
        .get();

    return snapshot.docs.map((e) {
      return GuestAccess.fromSnapshot(e);
    }).toList();
  }
}
