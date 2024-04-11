import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository _postRepository;
  final FileRepository _fileRepository;

  PostDetailBloc(
    PostRepository postRepository,
    FileRepository fileRepository,
  )   : _postRepository = postRepository,
        _fileRepository = fileRepository,
        super(PostDetailInitial()) {
    on<PostDetailEvent>((event, emit) {});
    on<PostDetailDeleteStarted>(_onPostDetailDeleteStarted);
    on<PostDetailModifyStarted>(_onPostDetailModifyStarted);
  }

  void _onPostDetailDeleteStarted(
    PostDetailDeleteStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(PostDetailLoadInProgress());
    try {
      if (event.post.image != null && event.post.image!.isNotEmpty) {
        await _fileRepository.deleteFile(path: event.post.image ?? '');
      }
      await _postRepository.delete(id: event.post.id ?? '');
      emit(PostDetailDeleteSuccess());
    } catch (e) {
      emit(PostDetailLoadFailure(error: e.toString()));
    }
  }

  void _onPostDetailModifyStarted(
    PostDetailModifyStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(PostDetailLoadInProgress());
    try {
      final post = event.post;
      emit(PostDetailLoadSuccess(post: post));
    } catch (e) {
      emit(PostDetailLoadFailure(error: e.toString()));
    }
  }
}
