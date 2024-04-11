part of 'post_detail_bloc.dart';

sealed class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class PostDetailDeleteStarted extends PostDetailEvent {
  final PostModel post;

  const PostDetailDeleteStarted({required this.post});

  @override
  List<Object> get props => [post];
}

class PostDetailModifyStarted extends PostDetailEvent {
  final PostModel post;

  const PostDetailModifyStarted({required this.post});

  @override
  List<Object> get props => [post];
}
