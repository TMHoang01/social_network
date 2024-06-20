import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/review_service.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:social_network/domain/repository/service/review_repository.dart';
import 'package:social_network/domain/repository/service/service_repository.dart';
import 'package:social_network/utils/utils.dart';
part 'service_detail_event.dart';
part 'service_detail_state.dart';

class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  final ReviewRepository reviewRepository;
  final ServiceRepository serviceRepository;

  ServiceDetailBloc(this.reviewRepository, this.serviceRepository)
      : super(const ServiceDetailState()) {
    on<ServiceDetailEvent>((event, emit) {});
    on<SericeDetiailInitial>(_onSericeDetiailInitial);
    on<ServiceDetailStarted>(_onServiceDetailStarted, transformer: droppable());
    on<SericeDetiailAddReviewInitial>(_onSericeDetiailAddReviewInitial);
    on<ServiceDetailAddReviewSubmit>(_onServiceDetailAddReview,
        transformer: droppable());
    on<ServiceDetailLoadMoreReview>(_onServiceDetailLoadMoreReview,
        transformer: droppable());
  }

  void _onSericeDetiailInitial(
    SericeDetiailInitial event,
    Emitter<ServiceDetailState> emit,
  ) {
    emit(const ServiceDetailState(
      status: ServiceDetailStatus.initial,
      service: null,
      myReview: null,
      listReview: null,
      isLoadMoreEnd: false,
      error: null,
    ));
  }

  void _onServiceDetailStarted(
    ServiceDetailStarted event,
    Emitter<ServiceDetailState> emit,
  ) async {
    emit(state.copyWith(status: ServiceDetailStatus.loading));
    try {
      final serviceId = event.service.id;
      if (serviceId == null) {
        emit(state.copyWith(status: ServiceDetailStatus.failure));
        return;
      }
      final listReview = await reviewRepository.getAllByServiceId(
        serviceId: serviceId,
        limit: 5,
      );
      final myReview = await reviewRepository.getMyReviewInService(
        userId: userCurrent?.uid ?? '',
        serviceId: serviceId,
      );
      // final myReview = listReview.firstWhereOrNull(
      //   (element) => element.userId == userCurrent?.uid,
      // );
      emit(
        ServiceDetailState(
          status: ServiceDetailStatus.loaded,
          service: event.service,
          listReview: listReview,
          myReview: myReview,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ServiceDetailStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void _onSericeDetiailAddReviewInitial(
    SericeDetiailAddReviewInitial event,
    Emitter<ServiceDetailState> emit,
  ) {
    // if (event.ratingInit == null) return;
    ReviewService? myReview = state.myReview;
    if (myReview != null) {
      myReview = myReview.copyWith(rating: event.ratingInit);
    } else {
      myReview = ReviewService(
        userId: userCurrent?.uid,
        userName: userCurrent?.username,
        userAvatar: userCurrent?.avatar,
        serviceId: state.service?.id,
        rating: event.ratingInit,
        createdAt: DateTime.now(),
      );
    }
    emit(state.copyWith(
      myReview: myReview,
    ));
    logger.i('myReview: ${state.myReview}');
  }

  void _onServiceDetailAddReview(
    ServiceDetailAddReviewSubmit event,
    Emitter<ServiceDetailState> emit,
  ) async {
    // emit(state.copyWith(status: ServiceDetailStatus.loading));
    try {
      ReviewService myReview = state.myReview?.copyWith(
            userName: userCurrent?.username,
            userAvatar: userCurrent?.avatar,
            comment: event.review.comment,
            rating: event.review.rating,
          ) ??
          ReviewService(
            userId: userCurrent?.uid,
            userName: userCurrent?.username,
            userAvatar: userCurrent?.avatar,
            serviceId: state.service?.id,
            rating: event.review.rating,
            comment: event.review.comment,
            createdAt: DateTime.now(),
          );
      if (myReview.id != null) {
        await reviewRepository.update(review: myReview);
        final index = state.listReview
            ?.indexWhere((element) => element.id == myReview.id);
        if (index != null && index >= 0) {
          final newList = List<ReviewService>.from(state.listReview ?? []);
          final oldRating = newList[index].rating?.toInt();
          final newRating = myReview.rating?.toInt();
          newList[index] = myReview;
          Map<int, int>? ratingCount = state.service?.ratingCount;
          ratingCount ??= {};
          if (oldRating != null) {
            ratingCount[oldRating] = (ratingCount[oldRating] ?? 1) - 1;
          }
          if (newRating != null) {
            ratingCount[newRating] = (ratingCount[newRating] ?? 0) + 1;
          }
          final serviceUpdate =
              state.service?.copyWith(ratingCount: ratingCount);
          emit(
            state.copyWith(
              service: serviceUpdate,
              status: ServiceDetailStatus.loaded,
              myReview: myReview,
              listReview: newList,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ServiceDetailStatus.loaded,
              myReview: myReview,
            ),
          );
        }
      } else {
        final review = await reviewRepository.add(review: myReview);
        if (review == null) {
          emit(state.copyWith(status: ServiceDetailStatus.failure));
          return;
        }
        final newRating = review.rating?.toInt() ?? 0;

        final countIntRating = state.service!.ratingCount?[newRating] ?? 0;
        emit(
          state.copyWith(
            service: state.service?.copyWith(
              ratingCount: {
                ...state.service?.ratingCount ?? {},
                newRating: countIntRating + 1,
              },
            ),
            status: ServiceDetailStatus.loaded,
            myReview: review,
            listReview: [review, ...state.listReview ?? []],
          ),
        );
      }

      logger.i('myReview: ${state.myReview}');
    } catch (e) {
      emit(state.copyWith(status: ServiceDetailStatus.failure));
    }
  }

  void _onServiceDetailLoadMoreReview(
    ServiceDetailLoadMoreReview event,
    Emitter<ServiceDetailState> emit,
  ) async {
    emit(state.copyWith(status: ServiceDetailStatus.loadmore));
    try {
      final serviceId = state.service?.id;
      final lastCreateAt = state.listReview?.last.createdAt;
      final listReviewMore = await reviewRepository.getAllByServiceId(
        serviceId: serviceId ?? '',
        lastCreateAt: lastCreateAt,
      );
      ServiceDetailState newState = state.copyWith(
        status: ServiceDetailStatus.loaded,
        listReview: [...state.listReview ?? [], ...listReviewMore],
      );
      if (listReviewMore.isEmpty || listReviewMore.length < LIMIT_PAGE) {
        newState = newState.copyWith(isLoadMoreEnd: true);
      }
      emit(newState);
    } catch (e) {
      emit(state.copyWith(status: ServiceDetailStatus.failure));
    }
  }
}
