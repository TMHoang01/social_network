part of 'posts_bloc.dart';

sealed class PostsClientEvent extends Equatable {
  const PostsClientEvent();

  @override
  List<Object> get props => [];
}

class PostsStarted extends PostsClientEvent {
  final String? type;

  const PostsStarted({this.type});
}

class PostsRetryStarted extends PostsClientEvent {}

class PostsRefreshStarted extends PostsClientEvent {}

class PostsLoadmoreEvent extends PostsClientEvent {
  final String? type;

  const PostsLoadmoreEvent({this.type});

  @override
  List<Object> get props => [];
}

class PostDeleteStarted extends PostsClientEvent {
  final PostModel post;

  const PostDeleteStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
