import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

class AuthFirebase {
  final _firebaseAuth = sl.call<FirebaseAuth>();
  final _googleSignIn = sl.call<GoogleSignIn>();

  Future<void> signUp({required String email, required String password}) async {
    try {
      final newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // tạm thời làm sao để có thể ghi vào firestore

      // create a new user in the database
      await saveUserToFirestore(newUser.user!.displayName ?? '', newUser.user!,
          newUser.user!.email ?? '', '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      logger.i(user);
      final doc = await usersRef.doc(user!.uid).get();
      // logger.i(doc);

      if (!doc.exists) {
        await saveUserToFirestore(
            user.displayName ?? '', user, user.email ?? '', '');
      }

      // await _saveLoggedInUser(userCredential.user);
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      var uid = _firebaseAuth.currentUser?.uid;
      UserModel? user;
      if (uid != null) {
        await usersRef.doc(uid).get().then((doc) {
          // merge user to the user from firestore
          if (doc.exists) {
            user = UserModel.fromDocumentSnapshot(doc);
          } else {
            usersRef.doc(uid).set({
              'username': _firebaseAuth.currentUser?.displayName ?? '',
              'email': _firebaseAuth.currentUser?.email ?? '',
              'created_at': DateTime.now(),
              'id': uid,
              'bio': "",
              'photoUrl': _firebaseAuth.currentUser?.photoURL ?? '',
            });
          }
        });
      }
      if (user == null && uid != null) {
        return null;
      }
      logger.i('user: $user');
      return user;
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  Future<void> saveUserToFirestore(
      String name, User user, String email, String country) async {
    try {
      await usersRef.doc(user.uid).set({
        'username': name,
        'email': email,
        'created_at': Timestamp.now(),
        'id': user.uid,
        'bio': "",
        'country': country,
        'photoUrl': user.photoURL ?? '',
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }
}
