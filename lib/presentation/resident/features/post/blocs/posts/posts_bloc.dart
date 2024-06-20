import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/logger.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsClientBloc extends Bloc<PostsClientEvent, PostsClientState> {
  final PostRepository _postRepository;
  PostsClientBloc(this._postRepository) : super(PostsInitial()) {
    on<PostsClientEvent>((event, emit) {});
    // droppable
    on<PostsStarted>(_onPostsStarted, transformer: droppable());
    on<PostsLoadmoreEvent>(_onPostsLoadmoreEvent, transformer: restartable());
  }

  List<PostModel> list = [];
  Map<String, String>? filter;
  bool isLoadMore = false;
  bool isLoadMoreEnd = false;

  void _onPostsStarted(
      PostsStarted event, Emitter<PostsClientState> emit) async {
    emit(PostsClientsLoadInProgress());
    try {
      // final posts = await _postRepository.getAll();
      Map<String, String>? filter;
      if (event.type != null) {
        filter = {
          'type': event.type!,
        };
      }
      final posts = await _postRepository.getAll(filter: filter);
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
      logger.e(e);
      emit(PostsLoadFailure(error: e.toString()));
    }
  }
}
