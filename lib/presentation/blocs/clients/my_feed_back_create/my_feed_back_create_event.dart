part of 'my_feed_back_create_bloc.dart';

sealed class MyFeedBackCreateEvent extends Equatable {
  const MyFeedBackCreateEvent();

  @override
  List<Object> get props => [];
}

class MyFeedBackCreateSubmit extends MyFeedBackCreateEvent {
  final FeedBackModel feedback;
  final String file;

  MyFeedBackCreateSubmit(this.feedback, this.file);

  @override
  List<Object> get props => [feedback, file];
}
