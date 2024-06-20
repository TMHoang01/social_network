part of 'post_detail_bloc.dart';

sealed class PostViewDetailState extends Equatable {
  const PostViewDetailState();

  @override
  List<Object> get props => [];
}

final class PostDetailInitial extends PostViewDetailState {}

final class PostDetailLoadInProgress extends PostViewDetailState {}

final class PostDetailLoadSuccess extends PostViewDetailState {
  final PostModel post;

  const PostDetailLoadSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostDetailLoadFailure extends PostViewDetailState {
  final String message;
  final bool? warning;
  const PostDetailLoadFailure({required this.message, this.warning});

  @override
  List<Object> get props => [message];
}
