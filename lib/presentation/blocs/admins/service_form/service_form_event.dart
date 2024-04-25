part of 'service_form_bloc.dart';

sealed class ServiceFormEvent extends Equatable {
  const ServiceFormEvent();

  @override
  List<Object> get props => [];
}

final class ServiceFormAddStarted extends ServiceFormEvent {}

final class ServiceFormSubmit extends ServiceFormEvent {
  final ServiceModel service;
  final String file;
  const ServiceFormSubmit({required this.service, required this.file});

  @override
  List<Object> get props => [service];
}

final class ServiceFormEditStarted extends ServiceFormEvent {}
