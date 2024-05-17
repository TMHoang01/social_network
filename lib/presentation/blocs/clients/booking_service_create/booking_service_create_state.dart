part of 'booking_service_create_bloc.dart';

enum BookingServiceCreateStatus { initial, loading, success, failure }

class BookingServiceCreateState extends Equatable {
  const BookingServiceCreateState(
      {this.status = BookingServiceCreateStatus.initial,
      this.service,
      this.booking,
      this.error,
      this.schedule});

  final BookingServiceCreateStatus status;
  final ServiceModel? service;
  final BookingService? booking;
  final ScheduleBooking? schedule;
  final String? error;

  BookingServiceCreateState copyWith({
    BookingServiceCreateStatus? status,
    ServiceModel? service,
    BookingService? booking,
    ScheduleBooking? schedule,
    String? error,
  }) {
    return BookingServiceCreateState(
      status: status ?? this.status,
      service: service ?? this.service,
      booking: booking ?? this.booking,
      schedule: schedule ?? this.schedule,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, service, booking, schedule, error];
}
