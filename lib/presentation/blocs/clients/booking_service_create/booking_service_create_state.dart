part of 'booking_service_create_bloc.dart';

sealed class BookingServiceCreateState extends Equatable {
  const BookingServiceCreateState();

  @override
  List<Object> get props => [];
}

final class BookingServiceCreateInitial extends BookingServiceCreateState {}

final class BookingServiceCreateChilCaredInitial
    extends BookingServiceCreateState {
  final BookingServiceChildCare booking;

  BookingServiceCreateChilCaredInitial({required this.booking});

  @override
  List<Object> get props => [booking];
}

// submitform
final class BookingServiceLoading extends BookingServiceCreateState {}

final class BookingServiceCreateSuccess extends BookingServiceCreateState {
  final BookingService bookingService;

  BookingServiceCreateSuccess(this.bookingService);

  @override
  List<Object> get props => [bookingService];
}

final class BookingServiceCreateFailure extends BookingServiceCreateState {
  final String message;

  BookingServiceCreateFailure(this.message);

  @override
  List<Object> get props => [message];
}
