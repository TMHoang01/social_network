part of 'my_feed_back_bloc.dart';

sealed class MyFeedBackState extends Equatable {
  const MyFeedBackState();

  @override
  List<Object> get props => [];
}

final class MyFeedBackInitial extends MyFeedBackState {}

final class MyFeedBackLoading extends MyFeedBackState {}

final class MyFeedBackLoaded extends MyFeedBackState {
  final List<FeedBackModel> feedBacks;

  MyFeedBackLoaded(this.feedBacks);

  @override
  List<Object> get props => [feedBacks];
}

final class MyFeedBackError extends MyFeedBackState {
  final String message;

  MyFeedBackError({required this.message});

  @override
  List<Object> get props => [message];
}
