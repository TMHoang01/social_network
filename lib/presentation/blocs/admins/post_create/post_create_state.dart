part of 'post_create_bloc.dart';

sealed class PostCreateState extends Equatable {
  const PostCreateState();

  @override
  List<Object> get props => [];
}

final class PostCreateInitial extends PostCreateState {}

final class PostCreateStarting extends PostCreateState {
  final PostType type;
  const PostCreateStarting({required this.type});
}

final class PostEditStarting extends PostCreateState {
  final PostModel post;
  const PostEditStarting({required this.post});
}

final class PostCreateInProcess extends PostCreateState {
  final PostModel post;

  const PostCreateInProcess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostCreateSuccess extends PostCreateState {
  final PostModel post;
  const PostCreateSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostCreateFailure extends PostCreateState {
  final PostModel post;
  final String error;
  const PostCreateFailure({required this.post, required this.error});

  @override
  List<Object> get props => [post, error];
}
