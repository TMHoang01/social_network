part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrder extends OrderEvent {
  final InforContactModel address;
  final List<CartItem> items;
  final double total;
  final String note;

  const CreateOrder(
      {required this.address,
      required this.items,
      required this.total,
      required this.note});

  @override
  List<Object> get props => [address, items, total, note];
}

class UpdateStatusOrder extends OrderEvent {
  final String id;
  final StatusOrder status;

  const UpdateStatusOrder({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}

class DeleteOrder extends OrderEvent {
  final String id;

  const DeleteOrder({required this.id});

  @override
  List<Object> get props => [id];
}

class GetAllOrder extends OrderEvent {
  const GetAllOrder();

  @override
  List<Object> get props => [];
}
