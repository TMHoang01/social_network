import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository _postRepository;
  PostsBloc(this._postRepository) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) {});
    on<PostsStarted>(_onPostsStarted);
    on<PostInsertStarted>(_onPostInsertStarted);
  }

  void _onPostsStarted(PostsStarted event, Emitter<PostsState> emit) async {
    emit(PostsLoadInProgress());
    try {
      final posts = await _postRepository.getAll();
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostInsertStarted(
      PostInsertStarted event, Emitter<PostsState> emit) async {
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
}
