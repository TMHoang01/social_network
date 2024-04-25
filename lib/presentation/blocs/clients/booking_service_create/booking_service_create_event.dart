part of 'booking_service_create_bloc.dart';

sealed class BookingServiceCreateEvent extends Equatable {
  const BookingServiceCreateEvent();

  @override
  List<Object> get props => [];
}

class BookingServiceCreateStared extends BookingServiceCreateEvent {
  final BookingService booking;

  BookingServiceCreateStared(this.booking);

  @override
  List<Object> get props => [booking];
}

class BookingServiceCreateSubmit extends BookingServiceCreateEvent {
  final BookingService booking;

  BookingServiceCreateSubmit(this.booking);

  @override
  List<Object> get props => [booking];
}
