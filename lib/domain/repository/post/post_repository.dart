import 'package:social_network/domain/models/post/post.dart';

abstract class PostRepository {
  // CRUD post
  Future<PostModel> add({required PostModel post});
  Future<void> update({required PostModel post});
  Future<void> delete({required String id});
  Future<List<PostModel>> getAll();
}
