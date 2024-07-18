part of 'service_detail_bloc.dart';

sealed class ServiceDetailEvent extends Equatable {
  const ServiceDetailEvent();

  @override
  List<Object> get props => [];
}

class SericeDetiailInitial extends ServiceDetailEvent {}

class ServiceDetailStarted extends ServiceDetailEvent {
  final ServiceModel service;
  ServiceDetailStarted(this.service);

  @override
  List<Object> get props => [service];
}

class SericeDetiailAddReviewInitial extends ServiceDetailEvent {
  final double? ratingInit;
  const SericeDetiailAddReviewInitial({this.ratingInit});
}

class ServiceDetailAddReviewSubmit extends ServiceDetailEvent {
  final ReviewService review;
  ServiceDetailAddReviewSubmit(this.review);

  @override
  List<Object> get props => [review];
}

class ServiceDetailDeleteMyReview extends ServiceDetailEvent {}

class ServiceDetailRefreshReview extends ServiceDetailEvent {}

class ServiceDetailLoadMoreReview extends ServiceDetailEvent {}
