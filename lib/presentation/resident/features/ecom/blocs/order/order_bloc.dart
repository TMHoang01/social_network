import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/ecom/order_model.dart';
import 'package:social_network/domain/repository/ecom/order_repository.dart';
import 'package:social_network/utils/firebase.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderRepository _orderRepository;
  OrderBloc(OrderRepository orderRepository)
      : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<GetAllOrder>((event, emit) => _getAllOrder(event, emit));
    on<CreateOrder>((event, emit) => _addOrder(event, emit));
  }

  void _getAllOrder(GetAllOrder event, Emitter<OrderState> emit) async {
    emit(OrdersLoading());
    try {
      final userId = firebaseAuth.currentUser!.uid;
      final orders = await _orderRepository.getAllByUserId(userId: userId);
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrderLoadError(message: e.toString()));
    }
  }

  void _addOrder(CreateOrder event, Emitter<OrderState> emit) async {
    final orders = (state as OrdersLoaded).orders ?? [];
    final userId = firebaseAuth.currentUser!.uid;
    emit(OrdersLoading());
    try {
      OrderModel order = OrderModel(
        userId: userId,
        address: event.address,
        items: event.items,
        total: event.total,
        status: StatusOrder.pending,
        createdAt: DateTime.now(),
      );
      order = await _orderRepository.add(oderModel: order);
      orders.insert(0, order);
      emit(OrderSuccessAdd(orders: orders));
    } catch (e) {
      emit(OrderLoadError(message: e.toString()));
    }
  }
}
