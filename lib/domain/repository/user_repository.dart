import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/provider/blocs/users/users_bloc.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(String id);
  Future<List<UserModel>> getUserPending();
  Future<List<UserModel>> getUsersQuery(UsersQuery query);
  Future<void> updateStatus(String userId, String status);

  Future<List<UserModel>> getListNotInClude(List<String> ids);
}
