import 'package:social_network/data/datasources/ecom/post_remote.dart';
import 'package:social_network/domain/models/post/joiners.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/utils.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _postDataSource;

  PostRepositoryImpl(this._postDataSource);

  @override
  Future<PostModel> add({required PostModel post}) async {
    final id = await _postDataSource.add(post: post);
    return post.copyWith(id: id);
  }

  @override
  Future<PostModel> get({required String id}) async {
    return await _postDataSource.get(id: id);
  }

  @override
  Future<void> update({required PostModel post}) async {
    return await _postDataSource.update(post: post);
  }

  @override
  Future<void> delete({required String id}) async {
    return await _postDataSource.delete(id: id);
  }

  @override
  Future<List<PostModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    return await _postDataSource.getAll(
        lastCreateAt: lastCreateAt, limit: limit, filter: filter);
  }

  @override
  Future<List<PostModel>> paginateQuey(
      {int limit = 20,
      String? query,
      String? type,
      DateTime? lastUpdate}) async {
    return await _postDataSource.paginateQuey(
        limit: limit, query: query, type: type, lastUpdate: lastUpdate);
  }

  @override
  Future<void> joinEvent(
      {required String id, required JoinersModel joiner}) async {
    return await _postDataSource.joinEvent(id: id, joiner: joiner);
  }

  @override
  Future<void> leaveEvent({required String id, required String userId}) async {
    return await _postDataSource.leaveEvent(id: id, userId: userId);
  }
}
