part of 'user_infor_bloc.dart';

sealed class UserInforState extends Equatable {
  const UserInforState();

  @override
  List<Object> get props => [];
}

final class UpdateInforInitial extends UserInforState {}

final class UserInforUpdateRoleStarted extends UserInforState {
  Role role;
  UserInforUpdateRoleStarted({this.role = Role.user});

  @override
  List<Object> get props => [role];

  UserInforUpdateRoleStarted copyWith({Role? role}) {
    return UserInforUpdateRoleStarted(role: role ?? this.role);
  }
}

final class UserInforProviderFormStarted extends UserInforState {}

final class UserInforResidentFormStarted extends UserInforState {}

final class UserInforUpdateInforFailure extends UserInforState {
  final String error;

  UserInforUpdateInforFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class UserInforUpdateInforSuccess extends UserInforState {}

final class UserInforUpdateInforLoading extends UserInforState {}
