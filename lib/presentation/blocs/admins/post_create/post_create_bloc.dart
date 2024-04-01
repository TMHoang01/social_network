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
    on<PostCreateStarted>(_onPostCreateStarted);
    on<PostCreateRetryStared>(_onPostCreateRetryStarted);
  }

  void _onPostCreateStarted(
      PostCreateStarted event, Emitter<PostCreateState> emit) async {
    PostModel post = PostModel(
      title: event.title,
      content: event.content,
      createdAt: DateTime.now(),
      createdBy: firebaseAuth.currentUser!.uid,
    );
    try {
      emit(
        PostCreateInProcess(post: post),
      );
      final imageUrl = await _uploadFile(
        event.image,
      );

      post = await _postRepository.add(post: post.copyWith(image: imageUrl));
      emit(PostCreateSuccess(post: post));
    } catch (e) {
      emit(PostCreateFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  void _onPostCreateRetryStarted(
      PostCreateRetryStared event, Emitter<PostCreateState> emit) async {
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

  Future<String?> _uploadFile(String imagePath) async {
    try {
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await _fileRepository.uploadFile(
        file: file,
        path: 'images/posts/$name',
      );
      return imageUrl;
    } catch (e) {
      print(e);
    }
  }
}
