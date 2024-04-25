import 'package:social_network/domain/models/ecom/order_model.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/service.dart';

abstract class OrderRepository {
  Future<OrderModel> add({required OrderModel oderModel});
  Future<BookingService> addService({required BookingService oderModel});
  Future<void> updateStatus({required String id, required StatusOrder status});

  Future<void> delete({required String id});

  Future<List<OrderModel>> getAllByUserId({required String userId});
}
