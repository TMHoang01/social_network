import 'package:social_network/domain/models/guest_access/guest_access.dart';
import 'package:social_network/domain/repository/guest_access/guest_access_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/utils/utils.dart';

part 'guest_access_event.dart';
part 'guest_access_state.dart';

class GuestAccessBloc extends Bloc<GuestAccessEvent, GuestAccessState> {
  final GuestAccessRepository guestAccessRepository;
  GuestAccessBloc(this.guestAccessRepository) : super(GuestAccessState()) {
    on<GuestAccessEvent>((event, emit) {});
    on<GuestAccessEventStarted>(_onStarted);
    on<GuestAccessCreateSubmit>(_onCreateSubmit);
    on<GuestAccessEventDetailStated>(_onDetailStated);
    on<GuestAccessEventCancel>(_onCancel);
  }

  void _onStarted(
      GuestAccessEventStarted event, Emitter<GuestAccessState> emit) async {
    emit(state.copyWith(status: GuestAccessStatus.loading));
    try {
      // final list = await guestAccessRepository.getByDate(DateTime.now());
      final list =
          await guestAccessRepository.getAllByUserId(userCurrent?.uid ?? '');
      emit(state.copyWith(status: GuestAccessStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(
          status: GuestAccessStatus.error, message: e.toString()));
    }
  }

  void _onCreateSubmit(
      GuestAccessCreateSubmit event, Emitter<GuestAccessState> emit) async {
    emit(state.copyWith(statusProcess: GuestAccessStatus.loading));
    try {
      GuestAccess? item = event.guestAccess.copyWith(
        createdBy: userCurrent?.uid,
        residentId: userCurrent?.uid,
        residentName: userCurrent?.username,
        // apartmentId: userCurrent?.apartmentId,
        createdAt: DateTime.now(),
      );

      item = await guestAccessRepository.add(item);

      emit(state.copyWith(
          statusProcess: GuestAccessStatus.loaded,
          list: [...state.list, item ?? GuestAccess()]));
    } catch (e) {
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.error, message: e.toString()));
    }
  }

  void _onDetailStated(GuestAccessEventDetailStated event,
      Emitter<GuestAccessState> emit) async {
    emit(state.copyWith(statusProcess: GuestAccessStatus.loading));
    try {
      // final guestAccess = await guestAccessRepository.getById(event.id);
      final guestAccess =
          state.list.firstWhere((element) => element.id == event.id);
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.loaded, select: guestAccess));
    } catch (e) {
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.error, message: e.toString()));
    }
  }

  void _onCancel(GuestAccessEventCancel event, Emitter<GuestAccessState> emit) {
    try {
      guestAccessRepository.delete(event.id);
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.loaded,
          list:
              state.list.where((element) => element.id != event.id).toList()));
    } catch (e) {
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.error, message: e.toString()));
    }
  }
}
