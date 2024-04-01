import 'package:social_network/data/datasources/ecom/post_remote.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _postDataSource;

  PostRepositoryImpl(this._postDataSource);

  @override
  Future<PostModel> add({required PostModel post}) async {
    final id = await _postDataSource.add(post: post);
    return post.copyWith(id: id);
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
  Future<List<PostModel>> getAll() async {
    return await _postDataSource.getAll();
  }
}
