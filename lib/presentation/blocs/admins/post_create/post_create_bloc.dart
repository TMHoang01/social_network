import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/file_repository.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'post_create_event.dart';
part 'post_create_state.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  final PostRepository _postRepository;
  final FileRepository _fileRepository;

  PostCreateBloc(
      {required PostRepository postRepository,
      required FileRepository fileRepository})
      : _fileRepository = fileRepository,
        _postRepository = postRepository,
        super(PostCreateInitial()) {
    on<PostCreateEvent>((event, emit) {});
    on<PostCreateInitEvent>(_onPostCreateInitType);
    on<PostCreateStartEvent>(_onPostCreateStarted);
    on<PostCreateRetryStartEvent>(_onPostCreateRetryStarted);

    on<PostEditInitEvent>(_onPostEditInit);
    on<PostEditStartEvent>(_onPostEditStarted);
  }

  void _onPostCreateInitType(
      PostCreateInitEvent event, Emitter<PostCreateState> emit) {
    emit(PostCreateStarting(type: event.type));
  }

  void _onPostEditInit(PostEditInitEvent event, Emitter<PostCreateState> emit) {
    emit(PostEditStarting(post: event.post));
  }

  void _onPostCreateStarted(
      PostCreateStartEvent event, Emitter<PostCreateState> emit) async {
    final post = (event.post.copyWith(
      createdAt: DateTime.now(),
      createdBy: firebaseAuth.currentUser!.uid,
    ));
    try {
      emit(
        PostCreateInProcess(post: post),
      );
      final imageUrl = await _uploadFile(
        imagePath: event.image,
      );

      final postSuccess =
          await _postRepository.add(post: post.copyWith(image: imageUrl));
      emit(PostCreateSuccess(post: postSuccess));
    } catch (e) {
      emit(PostCreateFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  void _onPostEditStarted(
      PostEditStartEvent event, Emitter<PostCreateState> emit) async {
    final post = (event.post.copyWith(
      updatedAt: DateTime.now(),
      updatedBy: firebaseAuth.currentUser!.uid,
    ));
    try {
      emit(
        PostCreateInProcess(post: post),
      );
      final imageUrl = await _uploadFile(
        imagePath: event.image,
        urlOld: post.image,
      );

      await _postRepository.update(post: post.copyWith(image: imageUrl));

      emit(PostCreateSuccess(post: post.copyWith(image: imageUrl)));
    } catch (e) {
      emit(PostCreateFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  void _onPostCreateRetryStarted(
      PostCreateRetryStartEvent event, Emitter<PostCreateState> emit) async {
    PostModel post = PostModel(
      title: event.title,
      content: event.content,
      createdAt: DateTime.now(),
      createdBy: firebaseAuth.currentUser!.uid,
    );
    try {
      emit(
        PostCreateInProcess(
          post: post,
        ),
      );

      emit(PostCreateSuccess(post: post));
    } catch (e) {
      emit(PostCreateFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  Future<String?> _uploadFile(
      {required String imagePath, String? urlOld}) async {
    try {
      if (imagePath.isEmpty) return null;
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await _fileRepository.uploadFile(
        file: file,
        path: 'images/posts/$name',
      );
      if (urlOld != null) {
        await _fileRepository.deleteFile(path: urlOld);
      }
      return imageUrl;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
