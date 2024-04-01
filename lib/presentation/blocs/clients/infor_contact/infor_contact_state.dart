part of 'infor_contact_bloc.dart';

sealed class InforContactState extends Equatable {
  const InforContactState();

  @override
  List<Object> get props => [];
}

final class InforContactInitial extends InforContactState {}

final class InforContactLoading extends InforContactState {}

final class InforContactLoaded extends InforContactState {
  final InforContactModel inforContact;
  const InforContactLoaded({required this.inforContact});

  @override
  List<Object> get props => [inforContact];
}

final class InforContactUpdated extends InforContactLoaded {
  const InforContactUpdated({required InforContactModel inforContact})
      : super(inforContact: inforContact);
}

final class InforContactEmpty extends InforContactState {}

final class InforContactError extends InforContactState {
  final String message;
  const InforContactError({required this.message});

  @override
  List<Object> get props => [message];
}
