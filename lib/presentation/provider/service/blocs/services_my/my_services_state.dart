part of 'my_services_bloc.dart';

sealed class MyServicesState extends Equatable {
  const MyServicesState();

  @override
  List<Object> get props => [];
}

final class MyServicesInitial extends MyServicesState {}

final class MyServicesLoading extends MyServicesState {}

final class MyServicesLoaded extends MyServicesState {
  final List<ServiceModel> services;

  const MyServicesLoaded({required this.services});

  @override
  List<Object> get props => [services];
}

final class MyServicesFailure extends MyServicesState {
  final String message;

  const MyServicesFailure(this.message);

  @override
  List<Object> get props => [message];
}
