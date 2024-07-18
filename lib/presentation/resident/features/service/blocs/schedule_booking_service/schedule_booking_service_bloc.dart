import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';
import 'package:social_network/domain/repository/service/schedule_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'schedile_booking_service_event.dart';
part 'schedule_booking_service_state.dart';

class ScheduleServiceResidentBloc
    extends Bloc<ScheduleServiceEvent, BookingServiceState> {
  final ScheduleServiceRepository scheduleingRepository;
  ScheduleServiceResidentBloc(this.scheduleingRepository)
      : super(BookingServiceInitial()) {
    on<ScheduleServiceEvent>((event, emit) {});
    on<ScheduleBServiceStared>((event, emit) async {
      emit(ScheduleServiceLoading());
      try {
        final bookingService = await scheduleingRepository.getScheduleInDay(
          userCurrent?.uid ?? '',
          event.day,
        );
        emit(BookingServiceSuccess(bookingService));
      } catch (e) {
        emit(ScheduleServiceFailure(e.toString()));
      }
    });
  }
}
