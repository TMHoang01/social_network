part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsStarted extends PostsEvent {}

class PostsRetryStarted extends PostsEvent {}

class PostsRefreshStarted extends PostsEvent {}

class PostsDeleteStarted extends PostsEvent {
  final String id;

  const PostsDeleteStarted({required this.id});

  @override
  List<Object> get props => [id];
}

class PostInsertStarted extends PostsEvent {
  final PostModel post;

  const PostInsertStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
