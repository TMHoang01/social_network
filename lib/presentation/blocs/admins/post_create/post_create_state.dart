part of 'post_create_bloc.dart';

sealed class PostCreateState extends Equatable {
  const PostCreateState();

  @override
  List<Object> get props => [];
}

final class PostCreateInitial extends PostCreateState {}

final class PostCreateInProcess extends PostCreateState {
  final PostModel post;

  PostCreateInProcess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostCreateSuccess extends PostCreateState {
  final PostModel post;
  PostCreateSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostCreateFailure extends PostCreateState {
  final PostModel post;
  final String error;
  PostCreateFailure({required this.post, required this.error});

  @override
  List<Object> get props => [post, error];
}
