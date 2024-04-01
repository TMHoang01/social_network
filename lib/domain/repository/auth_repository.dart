import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithGoogle();
  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
  Future<void> signUp({required String email, required String password});
  Future<void> saveUserToFirestore(
      String name, User user, String email, String country);
}
