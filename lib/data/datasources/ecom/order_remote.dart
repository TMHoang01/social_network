import 'package:social_network/domain/models/ecom/order_model.dart';
import 'package:social_network/utils/utils.dart';

class OrderRemote {
  Future<String> add({required OrderModel oderModel}) async {
    try {
      final doc = await orderRef.add(oderModel.toJson());
      return doc.id;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> updateStatus(
      {required String id, required StatusOrder status}) async {
    try {
      await orderRef.doc(id).update({'status': status.index});
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> delete({required String id}) async {}

  Future<List<OrderModel>> getAllByUserId({required String userId}) async {
    try {
      final querySnapshot =
          await orderRef.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((e) => OrderModel.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
