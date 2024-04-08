import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

part 'user_infor_event.dart';
part 'user_infor_state.dart';

class UserInforBloc extends Bloc<UserInforEvent, UserInforState> {
  final AuthRepository authRepository;
  final FileRepository fileRepository;
  UserInforBloc(
    this.authRepository,
    this.fileRepository,
  ) : super(UpdateInforInitial()) {
    on<UserInforEvent>((event, emit) {});
    on<UserInforUpdateRoleInit>(_updatetypeUserInit);
    on<UserInforSelectRoleAccount>(_selectRoleAccount);
    on<UserInforUpdateFormInfor>(_updateInforInit);
    on<UserInforUpdateInfor>(_updateInfor);
  }

  void _updatetypeUserInit(
      UserInforUpdateRoleInit event, Emitter<UserInforState> emit) {
    emit(UserInforUpdateRoleStarted());
  }

  void _selectRoleAccount(
      UserInforSelectRoleAccount event, Emitter<UserInforState> emit) {
    final roleSelect = event.role;
    logger.d('roleSelect: $roleSelect');
    emit(UserInforUpdateRoleStarted(role: roleSelect));
  }

  void _updateInforInit(
      UserInforUpdateFormInfor event, Emitter<UserInforState> emit) {
    final state = this.state;
    if (state is UserInforUpdateRoleStarted) {
      if (state.role == Role.provider) {
        emit(UserInforProviderFormStarted());
      } else if (state.role == Role.resident) {
        emit(UserInforResidentFormStarted());
      }
    }
  }

  void _updateInfor(
      UserInforUpdateInfor event, Emitter<UserInforState> emit) async {
    final state = this.state;
    UserModel user = event.user.copyWith(
      id: firebaseAuth.currentUser!.uid,
    );
    if (state is UserInforProviderFormStarted) {
      user = user.copyWith(roles: Role.provider);
    } else if (state is UserInforResidentFormStarted) {
      user = user.copyWith(roles: Role.resident);
    }

    try {
      emit(UserInforUpdateInforLoading());
      final imageUrl = await _uploadFile(
        event.avatar,
      );
      user = user.copyWith(avatar: imageUrl);
      await authRepository.updateInforUser(user);
      emit(UserInforUpdateInforSuccess());
    } catch (e) {
      emit(UserInforUpdateInforFailure(error: e.toString()));
    }
  }

  Future<String?> _uploadFile(String imagePath) async {
    try {
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await fileRepository.uploadFile(
        file: file,
        path: 'images/users/$name',
      );
      return imageUrl;
    } catch (e) {
      throw Exception(e);
    }
  }
}
