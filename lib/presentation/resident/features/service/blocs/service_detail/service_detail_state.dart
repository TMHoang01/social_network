part of 'service_detail_bloc.dart';

enum ServiceDetailStatus {
  initial,
  loading,
  loadmore,
  loaded,
  failure,
}

class ServiceDetailState extends Equatable {
  final ServiceDetailStatus? status;
  final ServiceModel? service;
  final ReviewService? myReview;
  final List<ReviewService>? listReview;
  final bool? isLoadMoreEnd;
  final String? error;
  final double? myRatingInit;
  const ServiceDetailState({
    this.status = ServiceDetailStatus.initial,
    this.service,
    this.myReview,
    this.listReview,
    this.isLoadMoreEnd = false,
    this.error,
    this.myRatingInit,
  });

  @override
  List<Object?> get props =>
      [status, service, myReview, listReview, isLoadMoreEnd, error];

  ServiceDetailState copyWith({
    ServiceDetailStatus? status,
    ServiceModel? service,
    ReviewService? myReview,
    List<ReviewService>? listReview,
    bool? isLoadMoreEnd,
    String? error,
    double? myRatingInit,
  }) {
    return ServiceDetailState(
      status: status ?? this.status,
      service: service ?? this.service,
      myReview: myReview ?? this.myReview,
      listReview: listReview ?? this.listReview,
      isLoadMoreEnd: isLoadMoreEnd,
      error: error,
      myRatingInit: myRatingInit,
    );
  }
}
