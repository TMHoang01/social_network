part of 'posts_bloc.dart';

sealed class PostsClientState extends Equatable {
  const PostsClientState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsClientState {}

final class PostsClientsLoadInProgress extends PostsClientState {}

final class PostsLoadSuccess extends PostsClientState {
  final List<PostModel> posts;

  const PostsLoadSuccess({required this.posts});

  @override
  List<Object> get props => [posts];
}

final class PostsLoadmoreEndSuccess extends PostsLoadSuccess {
  const PostsLoadmoreEndSuccess({required List<PostModel> posts})
      : super(posts: posts);
}

final class PostsLoadFailure extends PostsClientState {
  final String error;

  const PostsLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class PostsModifyInProgress extends PostsClientState {}

final class PostsDeleteInProgress extends PostsClientState {}
