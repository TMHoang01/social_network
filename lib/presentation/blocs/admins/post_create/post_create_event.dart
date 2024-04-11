part of 'post_create_bloc.dart';

sealed class PostCreateEvent extends Equatable {
  const PostCreateEvent();

  @override
  List<Object> get props => [];
}

class PostCreateInitEvent extends PostCreateEvent {
  final PostType type;

  const PostCreateInitEvent(this.type);
}

class PostCreateStartEvent extends PostCreateEvent {
  final PostModel post;
  final String image;

  const PostCreateStartEvent({
    required this.post,
    required this.image,
  });

  @override
  List<Object> get props => [post, image];
}

class PostCreateRetryStartEvent extends PostCreateEvent {
  final String imagePath;
  final String title;
  final String content;

  const PostCreateRetryStartEvent({
    required this.imagePath,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [title, content, imagePath];
}

class PostEditInitEvent extends PostCreateEvent {
  final PostModel post;

  const PostEditInitEvent(this.post);
}

class PostEditStartEvent extends PostCreateEvent {
  final PostModel post;
  final String image;

  const PostEditStartEvent({
    required this.post,
    required this.image,
  });

  @override
  List<Object> get props => [post, image];
}
