part of 'schedule_service_bloc.dart';

sealed class ScheduleServiceEvent extends Equatable {
  const ScheduleServiceEvent();

  @override
  List<Object> get props => [];
}

class ScheduleServiceStarted extends ScheduleServiceEvent {
  final String bookingId;

  const ScheduleServiceStarted(this.bookingId);
}

class ScheduleServiceUpdated extends ScheduleServiceEvent {
  final ScheduleItem schedule;

  const ScheduleServiceUpdated(this.schedule);

  @override
  List<Object> get props => [schedule];
}
