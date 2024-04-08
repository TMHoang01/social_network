part of 'user_infor_bloc.dart';

sealed class UserInforEvent extends Equatable {
  const UserInforEvent();

  @override
  List<Object> get props => [];
}

class UserInforUpdateRoleInit extends UserInforEvent {}

class UserInforSelectRoleAccount extends UserInforEvent {
  final Role role;

  const UserInforSelectRoleAccount({required this.role});

  @override
  List<Object> get props => [role];
}

class UserInforUpdateFormInfor extends UserInforEvent {
  const UserInforUpdateFormInfor();

  @override
  List<Object> get props => [];
}

class UserInforUpdateInfor extends UserInforEvent {
  final UserModel user;
  final String avatar;
  const UserInforUpdateInfor({required this.user, required this.avatar});

  @override
  List<Object> get props => [user, avatar];
}
