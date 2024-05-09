part of 'booking_service_bloc.dart';

sealed class BookingServiceState extends Equatable {
  const BookingServiceState();

  @override
  List<Object> get props => [];
}

final class BookingServiceInitial extends BookingServiceState {}

final class BookingServiceLoading extends BookingServiceState {}

final class BookingServiceSuccess extends BookingServiceState {
  final List<BookingService> bookingService;

  BookingServiceSuccess(this.bookingService);

  @override
  List<Object> get props => [bookingService];
}

final class BookingServiceFailure extends BookingServiceState {
  final String message;

  BookingServiceFailure(this.message);

  @override
  List<Object> get props => [message];
}
