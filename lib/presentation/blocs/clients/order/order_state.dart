part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrdersLoading extends OrderState {}

final class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  const OrdersLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class OrderLoadError extends OrderState {
  final String message;
  const OrderLoadError({required this.message});

  @override
  List<Object> get props => [message];
}

final class OrderHandling extends OrdersLoaded {
  const OrderHandling({required List<OrderModel> orders})
      : super(orders: orders);

  @override
  List<Object> get props => [orders];
}

final class OrderSuccessAdd extends OrdersLoaded {
  const OrderSuccessAdd({required List<OrderModel> orders})
      : super(orders: orders);
  @override
  List<Object> get props => [orders];
}

final class OrderSuccessUpdate extends OrdersLoaded {
  final OrderModel order;
  const OrderSuccessUpdate(
      {required this.order, required List<OrderModel> orders})
      : super(orders: orders);

  @override
  List<Object> get props => [order, orders];
}

final class OrderSuccessDelete extends OrdersLoaded {
  final String id;
  const OrderSuccessDelete({required this.id, required List<OrderModel> orders})
      : super(orders: orders);

  @override
  List<Object> get props => [id];
}

final class OrderHandleError extends OrdersLoaded {
  const OrderHandleError(
      {required OrderModel order, required List<OrderModel> orders})
      : super(orders: orders);

  @override
  List<Object> get props => [orders];
}
