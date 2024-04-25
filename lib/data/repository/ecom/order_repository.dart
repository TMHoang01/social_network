import 'package:social_network/data/datasources/ecom/order_remote.dart';
import 'package:social_network/domain/models/ecom/order_model.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/repository/ecom/order_repository.dart';

class OrderRepositoryIml implements OrderRepository {
  final OrderRemote _orderRemote;
  OrderRepositoryIml(OrderRemote orderRemote) : _orderRemote = orderRemote;

  @override
  Future<OrderModel> add({required OrderModel oderModel}) async {
    final id = await _orderRemote.add(oderModel: oderModel);
    return oderModel.copyWith(id: id);
  }

  @override
  Future<BookingService> addService({required BookingService oderModel}) async {
    return await _orderRemote.addService(oderModel: oderModel);
  }

  @override
  Future<void> updateStatus(
      {required String id, required StatusOrder status}) async {
    await _orderRemote.updateStatus(id: id, status: status);
  }

  @override
  Future<void> delete({required String id}) async {}

  @override
  Future<List<OrderModel>> getAllByUserId({required String userId}) async {
    return await _orderRemote.getAllByUserId(userId: userId);
  }
}
