import 'package:social_network/domain/models/ecom/category_model.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/repository/ecom/category_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

class InforContactRemote {
  Future<String?> add(InforContactModel inforContactModel) async {
    try {
      final doc = await inforContactRef.add(inforContactModel.toJson());
      return doc.id;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<InforContactModel?> findByUserId({required String userId}) async {
    try {
      final querySnapshot =
          await inforContactRef.where('userId', isEqualTo: userId).get();
      final doc = querySnapshot.docs.firstOrNull;
      if (doc != null) {
        return InforContactModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> update(
      {required String id,
      required InforContactModel inforContactModel}) async {
    try {
      await inforContactRef.doc(id).update(inforContactModel.toJson());
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
