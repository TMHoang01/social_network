import 'package:social_network/domain/models/ecom/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> add({required OrderModel oderModel});

  Future<void> updateStatus({required String id, required StatusOrder status});

  Future<void> delete({required String id});

  Future<List<OrderModel>> getAllByUserId({required String userId});
}
