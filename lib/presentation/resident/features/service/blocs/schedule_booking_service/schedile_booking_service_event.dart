part of 'schedule_booking_service_bloc.dart';

sealed class ScheduleServiceEvent extends Equatable {
  const ScheduleServiceEvent();

  @override
  List<Object> get props => [];
}

class ScheduleBServiceStared extends ScheduleServiceEvent {
  final DateTime day;

  ScheduleBServiceStared(this.day);

  @override
  List<Object> get props => [day];
}

class ScheduleBookingServiceCancelled extends ScheduleServiceEvent {
  final BookingService bookingService;

  const ScheduleBookingServiceCancelled(this.bookingService);
}
