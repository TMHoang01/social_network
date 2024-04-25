part of 'post_detail_bloc.dart';

sealed class PostViewDetailEvent extends Equatable {
  const PostViewDetailEvent();

  @override
  List<Object> get props => [];
}

class PostDetailDeleteStarted extends PostViewDetailEvent {
  final PostModel post;

  const PostDetailDeleteStarted({required this.post});

  @override
  List<Object> get props => [post];
}

class PostDetailModifyStarted extends PostViewDetailEvent {
  final PostModel post;

  const PostDetailModifyStarted({required this.post});

  @override
  List<Object> get props => [post];
}

class PostJoinEvent extends PostViewDetailEvent {
  final EventModel post;

  const PostJoinEvent({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
