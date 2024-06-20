import 'package:social_network/data/datasources/user_remote.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/user_repository.dart';
import 'package:social_network/presentation/provider/blocs/users/users_bloc.dart';

class UserRepositoryIml implements UserRepository {
  UserRemote _userRemote;

  UserRepositoryIml(UserRemote userRemote) : _userRemote = userRemote;

  @override
  Future<UserModel> getUserById(String id) async {
    return _userRemote.getUser(id);
  }

  @override
  Future<List<UserModel>> getUserPending() async {
    return _userRemote.getUserPending();
  }

  @override
  Future<void> updateStatus(String userId, String status) async {
    return _userRemote.updateStatus(userId, status);
  }

  @override
  Future<List<UserModel>> getUsersQuery(UsersQuery query) async {
    return _userRemote.getUsersQuery(query);
  }

  @override
  Future<List<UserModel>> getListNotInClude(List<String> ids) async {
    return _userRemote.getListNotInIds(ids);
  }
}
