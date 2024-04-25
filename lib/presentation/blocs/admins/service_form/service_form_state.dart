part of 'service_form_bloc.dart';

sealed class ServiceFormState extends Equatable {
  const ServiceFormState();

  @override
  List<Object> get props => [];
}

final class ServiceFormInitial extends ServiceFormState {}

final class ServiceFormAddInitial extends ServiceFormState {}

final class ServiceFormAddInProgress extends ServiceFormState {}

final class ServiceFormAddSuccess extends ServiceFormState {}

final class ServiceFormAddFailure extends ServiceFormState {
  final String message;

  const ServiceFormAddFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class ServiceFormEditInitial extends ServiceFormState {}

final class ServiceFormEditInProgress extends ServiceFormState {}

final class ServiceFormEditSuccess extends ServiceFormState {}

final class ServiceFormEditFailure extends ServiceFormState {
  final String message;

  const ServiceFormEditFailure(this.message);

  @override
  List<Object> get props => [message];
}
