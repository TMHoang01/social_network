import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';
import 'package:social_network/domain/repository/service/schedule_repository.dart';
import 'package:social_network/utils/logger.dart';

part 'schedule_service_event.dart';
part 'schedule_service_state.dart';

class ScheduleServiceBloc
    extends Bloc<ScheduleServiceEvent, ScheduleServiceState> {
  final ScheduleServiceRepository scheduleServiceRepository;
  ScheduleServiceBloc(this.scheduleServiceRepository)
      : super(ScheduleServiceState()) {
    on<ScheduleServiceEvent>((event, emit) {});
    on<ScheduleServiceStarted>(_onScheduleServiceStarted);
    on<ScheduleServiceUpdated>(_onScheduleServiceUpdated);
  }

  void _onScheduleServiceStarted(
    ScheduleServiceStarted event,
    Emitter<ScheduleServiceState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleServiceStatus.loading));
    try {
      final schedules = await scheduleServiceRepository.getAllByBookingId(
          bookingId: event.bookingId);
      emit(state.copyWith(
          status: ScheduleServiceStatus.success, list: schedules));
    } catch (e) {
      emit(state.copyWith(status: ScheduleServiceStatus.failure));
    }
  }

  void _onScheduleServiceUpdated(
    ScheduleServiceUpdated event,
    Emitter<ScheduleServiceState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleServiceStatus.loading));
    try {
      if (event.schedule.status == null) return;
      await scheduleServiceRepository.updateStatus(
          id: event.schedule.id ?? '', status: event.schedule.status!);
      List<ScheduleItem> list = state.list
              ?.map((e) => e.id == event.schedule.id ? event.schedule : e)
              .toList() ??
          [];
      list = [...list];

      emit(state.copyWith(status: ScheduleServiceStatus.success, list: list));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ScheduleServiceStatus.failure));
    }
  }
}
