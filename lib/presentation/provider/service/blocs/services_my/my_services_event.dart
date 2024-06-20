part of 'my_services_bloc.dart';

sealed class MyServicesEvent extends Equatable {
  const MyServicesEvent();

  @override
  List<Object> get props => [];
}

final class MyServicesStarted extends MyServicesEvent {}
