part of 'my_post_provider_bloc.dart';

sealed class MyPostProviderEvent extends Equatable {
  const MyPostProviderEvent();

  @override
  List<Object> get props => [];
}

class MyPostProviderStarted extends MyPostProviderEvent {}

class MyPostProviderInsertStarted extends MyPostProviderEvent {
  final PostModel post;

  const MyPostProviderInsertStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
