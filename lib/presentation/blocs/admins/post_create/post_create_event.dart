part of 'post_create_bloc.dart';

sealed class PostCreateEvent extends Equatable {
  const PostCreateEvent();

  @override
  List<Object> get props => [];
}

class PostCreateStarted extends PostCreateEvent {
  final String image;
  final String title;
  final String content;

  const PostCreateStarted({
    required this.image,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [title, content, image];
}

class PostCreateRetryStared extends PostCreateEvent {
  final String imagePath;
  final String title;
  final String content;

  const PostCreateRetryStared({
    required this.imagePath,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [title, content, imagePath];
}
