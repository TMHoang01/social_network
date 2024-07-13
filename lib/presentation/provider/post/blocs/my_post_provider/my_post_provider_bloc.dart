import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/domain/repository/post/post_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'my_post_provider_event.dart';
part 'my_post_provider_state.dart';

class MyPostProviderBloc
    extends Bloc<MyPostProviderEvent, MyPostProviderState> {
  final PostRepository _postRepository;

  MyPostProviderBloc(this._postRepository)
      : super(const MyPostProviderState()) {
    on<MyPostProviderEvent>((event, emit) {});
    on<MyPostProviderStarted>(_onStarted);
    on<MyPostProviderInsertStarted>(_onPostInsertStarted);
  }

  _onStarted(
      MyPostProviderStarted event, Emitter<MyPostProviderState> emit) async {
    emit(state.copyWith(status: MyPostProviderStatus.loading));
    try {
      Map<String, String>? fillter = new Map<String, String>();
      fillter['createdBy'] = userCurrent?.uid ?? '';
      final list = await _postRepository.getAll(filter: fillter);
      emit(state.copyWith(status: MyPostProviderStatus.loaded, list: list));
    } catch (e) {
      emit(
        state.copyWith(
            status: MyPostProviderStatus.error, message: e.toString()),
      );
    }
  }

  _onPostInsertStarted(MyPostProviderInsertStarted event,
      Emitter<MyPostProviderState> emit) async {
    final list = state.list;
    list.insert(0, event.post);
    emit(state.copyWith(
      list: list,
    ));
  }
}
