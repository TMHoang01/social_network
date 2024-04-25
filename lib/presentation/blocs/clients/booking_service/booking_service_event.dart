part of 'booking_service_bloc.dart';

sealed class BookingServiceEvent extends Equatable {
  const BookingServiceEvent();

  @override
  List<Object> get props => [];
}

class BookingServiceStared extends BookingServiceEvent {
  final DateTime date;

  BookingServiceStared(this.date);

  @override
  List<Object> get props => [date];
}
