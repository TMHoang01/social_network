import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/joiners.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostViewDetailBloc
    extends Bloc<PostViewDetailEvent, PostViewDetailState> {
  final PostRepository _postRepository;
  final AuthRepository _authRepository;
  PostViewDetailBloc(
    PostRepository postRepository,
    AuthRepository authRepository,
  )   : _postRepository = postRepository,
        _authRepository = authRepository,
        super(PostDetailInitial()) {
    on<PostDetailLoadStarted>(_onPostDetailLoadStarted);
    on<PostJoinEvent>(_onPostJoinEvent);
    on<PostLeaveEvent>(_onPostLeaveEvent);
  }

  Future<void> _onPostDetailLoadStarted(
    PostDetailLoadStarted event,
    Emitter<PostViewDetailState> emit,
  ) async {
    try {
      emit(PostDetailLoadInProgress());
      final post = await _postRepository.get(id: event.post.id ?? '');
      emit(PostDetailLoadSuccess(post: post));
    } catch (e) {
      logger.e(e);
      emit(PostDetailLoadFailure(message: e.toString()));
    }
  }

  void _onPostJoinEvent(
    PostJoinEvent event,
    Emitter<PostViewDetailState> emit,
  ) async {
    try {
      final post = event.post;
      if (post.isEnded) {
        emit(const PostDetailLoadFailure(
            message: 'Sự kện đã kết thúc', warning: true));
        return;
      }
      if (post.checkFullJoiners) {
        emit(const PostDetailLoadFailure(
            message: 'Sự kiện đã đủ người tham gia', warning: true));
        return;
      }

      emit(PostDetailLoadInProgress());
      final newJoiner = JoinersModel(
        id: userCurrent?.id ?? '',
        name: userCurrent?.username ?? '',
        avatar: userCurrent?.avatar ?? '',
      );

      await _postRepository.joinEvent(
        id: post.id ?? '',
        joiner: newJoiner,
      );
      final newEvent = post.copyWith(
        joinerIds: [...post.joinerIds ?? [], userCurrent?.id ?? ''],
      );

      emit(PostDetailLoadSuccess(post: newEvent));
    } catch (e) {
      logger.e(e);
      emit(PostDetailLoadFailure(message: e.toString()));
    }
  }

  void _onPostLeaveEvent(
    PostLeaveEvent event,
    Emitter<PostViewDetailState> emit,
  ) async {
    try {
      final post = event.post;
      if (post.isEnded) {
        emit(const PostDetailLoadFailure(
            message: 'Sự kện đã kết thúc', warning: true));
        return;
      }

      emit(PostDetailLoadInProgress());

      await _postRepository.leaveEvent(
        id: post.id ?? '',
        userId: userCurrent?.id ?? '',
      );

      final newEvent = post.copyWith(
        joinerIds: post.joinerIds
            ?.where((element) => element != userCurrent?.id)
            .toList(),
      );

      emit(PostDetailLoadSuccess(post: newEvent));
    } catch (e) {
      logger.e(e);
      emit(PostDetailLoadFailure(message: e.toString()));
    }
  }
}
