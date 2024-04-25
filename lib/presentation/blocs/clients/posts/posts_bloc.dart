import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsClientBloc extends Bloc<PostsClientEvent, PostsClientState> {
  final PostRepository _postRepository;
  PostsClientBloc(this._postRepository) : super(PostsInitial()) {
    on<PostsClientEvent>((event, emit) {});
    // droppable
    on<PostsStarted>(_onPostsStarted, transformer: droppable());
    on<PostInsertStarted>(_onPostInsertStarted);
    on<PostUpdateStarted>(_onPostUpdateStarted);
    on<PostsLoadmoreEvent>(_onPostsLoadmoreEvent, transformer: restartable());
  }

  void _onPostsStarted(
      PostsStarted event, Emitter<PostsClientState> emit) async {
    emit(PostsClientsLoadInProgress());
    try {
      final posts = await _postRepository.getAll();
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostInsertStarted(
      PostInsertStarted event, Emitter<PostsClientState> emit) async {
    final post = event.post;
    try {
      final posts = (state as PostsLoadSuccess).posts;
      emit(
        PostsModifyInProgress(),
      );

      posts.insert(0, post);
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostUpdateStarted(
      PostUpdateStarted event, Emitter<PostsClientState> emit) async {
    final post = event.post;
    try {
      final posts = (state as PostsLoadSuccess).posts;
      emit(
        PostsModifyInProgress(),
      );

      final index = posts.indexWhere((element) => element.id == post.id);
      posts[index] = post;
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostsLoadmoreEvent(
      PostsLoadmoreEvent event, Emitter<PostsClientState> emit) async {
    final type = event.type;
    final currentPosts = switch (state) {
      PostsLoadSuccess(posts: final posts) => posts,
      _ => [],
    };
    final lastUpdate =
        currentPosts.isNotEmpty ? currentPosts.last.createdAt : null;

    try {
      const limit = 5;
      final posts = await _postRepository.paginateQuey(
          limit: limit, lastUpdate: lastUpdate, type: type);
      if (posts.isEmpty || posts.length < limit) {
        emit(PostsLoadmoreEndSuccess(posts: [...currentPosts]));
        return;
      }
      emit(PostsLoadSuccess(posts: [...currentPosts, ...posts]));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }
}
