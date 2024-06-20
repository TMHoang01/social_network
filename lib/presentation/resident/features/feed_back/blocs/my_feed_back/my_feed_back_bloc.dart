import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/domain/repository/feed_back/feed_back_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/utils/firebase.dart';

part 'my_feed_back_event.dart';
part 'my_feed_back_state.dart';

class MyFeedBackBloc extends Bloc<MyFeedBackEvent, MyFeedBackState> {
  final FeedBackRepository feedBackRepository;
  final FileRepository fileRepository;
  MyFeedBackBloc(this.feedBackRepository, this.fileRepository)
      : super(MyFeedBackInitial()) {
    on<MyFeedBackEvent>((event, emit) {});
    on<MyFeedBackStared>(_onMyFeedBackStared);
    on<MyFeedBackReviewFeedBack>(_onMyFeedBackReviewFeedBack);
  }

  void _onMyFeedBackStared(
      MyFeedBackStared event, Emitter<MyFeedBackState> emit) async {
    emit(MyFeedBackLoading());

    try {
      final userId = firebaseAuth.currentUser!.uid;
      final feedBacks = feedBackRepository.getAllByUserId(userId: userId);
      await emit.forEach(
        feedBacks,
        onData: (feedBacks) {
          return MyFeedBackLoaded(feedBacks);
        },
        onError: (e, stackTrace) {
          return MyFeedBackError(message: e.toString());
        },
      );
    } catch (e) {
      emit(MyFeedBackError(message: e.toString()));
    }
  }

  void _onMyFeedBackReviewFeedBack(
      MyFeedBackReviewFeedBack event, Emitter<MyFeedBackState> emit) async {
    if (state is MyFeedBackLoaded) {
      final feedBacks = (state as MyFeedBackLoaded).feedBacks;
      try {
        final feedBack = FeedBackModel(
          id: event.feedBackId,
          rating: event.rating,
          review: event.review,
          status: FeedBackStatus.reviewed,
        );
        await feedBackRepository.update(feedBack: feedBack);
        emit(MyFeedBackLoaded(feedBacks.map((e) {
          if (e.id == event.feedBackId) {
            return e.copyWith(
                review: event.review,
                status: FeedBackStatus.reviewed,
                rating: event.rating);
          }
          return e;
        }).toList()));
      } catch (e) {
        emit(MyFeedBackError(message: e.toString()));
      }
    }
  }
}
