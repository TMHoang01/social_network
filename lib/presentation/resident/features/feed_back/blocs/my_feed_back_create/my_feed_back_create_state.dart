part of 'my_feed_back_create_bloc.dart';

sealed class MyFeedBackCreateState extends Equatable {
  const MyFeedBackCreateState();

  @override
  List<Object> get props => [];
}

final class MyFeedBackCreateInitial extends MyFeedBackCreateState {}

final class MyFeedBackCreateLoanding extends MyFeedBackCreateState {}

final class MyFeedBackCreatedSuccess extends MyFeedBackCreateState {}

final class MyFeedBackCreateError extends MyFeedBackCreateState {
  final String message;

  const MyFeedBackCreateError({required this.message});

  @override
  List<Object> get props => [message];
}
