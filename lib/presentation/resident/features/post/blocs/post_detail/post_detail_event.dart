part of 'post_detail_bloc.dart';

sealed class PostViewDetailEvent extends Equatable {
  const PostViewDetailEvent();

  @override
  List<Object> get props => [];
}

class PostDetailLoadStarted extends PostViewDetailEvent {
  final PostModel post;

  const PostDetailLoadStarted({
    required this.post,
  });

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

class PostLeaveEvent extends PostViewDetailEvent {
  final EventModel post;

  const PostLeaveEvent({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
