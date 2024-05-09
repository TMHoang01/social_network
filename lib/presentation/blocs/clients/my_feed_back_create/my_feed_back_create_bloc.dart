import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/domain/repository/feed_back/feed_back_repository.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'my_feed_back_create_event.dart';
part 'my_feed_back_create_state.dart';

class MyFeedBackCreateBloc
    extends Bloc<MyFeedBackCreateEvent, MyFeedBackCreateState> {
  final FeedBackRepository feedBackRepository;
  final FileRepository fileRepository;
  MyFeedBackCreateBloc(this.feedBackRepository, this.fileRepository)
      : super(MyFeedBackCreateInitial()) {
    on<MyFeedBackCreateEvent>((event, emit) {});
    on<MyFeedBackCreateSubmit>(_onMyFeedBackCreated, transformer: droppable());
  }
  void _onMyFeedBackCreated(
      MyFeedBackCreateSubmit event, Emitter<MyFeedBackCreateState> emit) async {
    emit(MyFeedBackCreateLoanding());

    try {
      final userId = userCurrent?.id;
      FeedBackModel feedBack = event.feedback.copyWith(
        userId: userId,
        userName: userCurrent?.username,
        createdAt: DateTime.now(),
        status: FeedBackStatus.pending,
      );
      final imagePath = event.file;
      if (imagePath.isNotEmpty) {
        File file = File(imagePath);
        String name = DateTime.now().millisecondsSinceEpoch.toString();
        name = '$name.${imagePath.split('.').last}';
        final url = await fileRepository.uploadFile(
            file: file, path: 'images/feed_backs/$name');
        feedBack = feedBack.copyWith(image: url);
      }
      await feedBackRepository.add(feedBack: feedBack);
      emit(MyFeedBackCreatedSuccess());
      // emit(MyFeedBackStared([]));
    } catch (e) {
      emit(MyFeedBackCreateError(message: e.toString()));
    }
  }
}
