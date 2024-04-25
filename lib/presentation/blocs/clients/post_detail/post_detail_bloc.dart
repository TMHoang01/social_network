import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/joiners.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/domain/repository/auth_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/firebase.dart';
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
    on<PostViewDetailEvent>((event, emit) {});
    on<PostDetailDeleteStarted>(_onPostDetailDeleteStarted);
    on<PostDetailModifyStarted>(_onPostDetailModifyStarted);
    on<PostJoinEvent>(_onPostJoinEvent);
  }

  void _onPostDetailDeleteStarted(
    PostDetailDeleteStarted event,
    Emitter<PostViewDetailState> emit,
  ) async {}

  void _onPostDetailModifyStarted(
    PostDetailModifyStarted event,
    Emitter<PostViewDetailState> emit,
  ) async {
    emit(PostDetailLoadInProgress());
    try {
      final post = event.post;
      emit(PostDetailLoadSuccess(post: post));
    } catch (e) {
      emit(PostDetailLoadFailure(error: e.toString()));
    }
  }

  void _onPostJoinEvent(
    PostJoinEvent event,
    Emitter<PostViewDetailState> emit,
  ) async {
    final post = event.post;
    if (post.endDate != null &&
        post.endDate!.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      emit(const PostDetailLoadFailure(error: 'Sự kện đã kết thúc'));
      return;
    }
    if (post.joinersCount != null && post.joinersCount! >= post.maxJoiners!) {
      emit(const PostDetailLoadFailure(error: 'Sự kiện đã đủ người tham gia'));
      return;
    }

    emit(PostDetailLoadInProgress());
    try {
      final post = event.post;
      final UserModel? auth = await _authRepository.getCurrentUser();
      final newJoiner = JoinersModel(
        id: auth?.id ?? '',
        name: auth?.username ?? '',
        avatar: auth?.avatar ?? '',
      );

      await _postRepository.joinEvent(
        id: post.id ?? '',
        joiner: newJoiner,
      );

      emit(PostDetailLoadSuccess(post: post));
    } catch (e) {
      logger.e(e);
      emit(PostDetailLoadFailure(error: e.toString()));
    }
  }
}
