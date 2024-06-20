part of 'my_feed_back_bloc.dart';

sealed class MyFeedBackEvent extends Equatable {
  const MyFeedBackEvent();

  @override
  List<Object> get props => [];
}

class MyFeedBackStared extends MyFeedBackEvent {}

class MyFeedBackReviewFeedBack extends MyFeedBackEvent {
  final String feedBackId;
  final double rating;
  final String review;

  const MyFeedBackReviewFeedBack(this.feedBackId, this.rating, this.review);

  @override
  List<Object> get props => [feedBackId, rating, review];
}
