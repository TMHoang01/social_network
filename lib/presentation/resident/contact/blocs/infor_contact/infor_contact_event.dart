part of 'infor_contact_bloc.dart';

sealed class InforContactEvent extends Equatable {
  const InforContactEvent();

  @override
  List<Object> get props => [];
}

class GetInforContact extends InforContactEvent {}

class SaveInforContact extends InforContactEvent {
  final String username;
  final String address;
  final String phone;
  const SaveInforContact(
      {required this.username, required this.address, required this.phone});

  @override
  List<Object> get props => [username, address, phone];
}
