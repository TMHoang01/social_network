part of 'schedule_booking_service_bloc.dart';

sealed class BookingServiceState extends Equatable {
  const BookingServiceState();

  @override
  List<Object> get props => [];
}

final class BookingServiceInitial extends BookingServiceState {}

final class ScheduleServiceLoading extends BookingServiceState {}

final class BookingServiceSuccess extends BookingServiceState {
  final List<ScheduleItem> scheduleService;

  BookingServiceSuccess(this.scheduleService);

  @override
  List<Object> get props => [scheduleService];
}

final class ScheduleServiceFailure extends BookingServiceState {
  final String message;

  ScheduleServiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class BookingServiceDetailLoading extends BookingServiceState {}

final class BookingServiceDetailSuccess extends BookingServiceState {}

final class BookingServiceDetailFailure extends BookingServiceState {}
