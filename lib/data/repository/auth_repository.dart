import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/data/datasources/auth_remote.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/utils/firebase.dart';

class AuthRepositoryIml implements AuthRepository {
  final AuthFirebase _authService;
  AuthRepositoryIml(AuthFirebase authService) : _authService = authService;

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _authService.signUp(email: email, password: password);
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _authService.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    userCurrent = await _authService.getCurrentUser();
    return userCurrent;
  }

  @override
  Future<void> saveUserToFirestore(
      String name, User user, String email, String country) async {
    await _authService.saveUserToFirestore(name, user, email, country);
  }

  @override
  Future<void> updateInforUser(UserModel user) async {
    await _authService.updateInforUser(user);
  }
}
