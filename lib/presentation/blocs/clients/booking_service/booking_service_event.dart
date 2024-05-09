part of 'booking_service_bloc.dart';

sealed class BookingServiceEvent extends Equatable {
  const BookingServiceEvent();

  @override
  List<Object> get props => [];
}

class BookingServiceStared extends BookingServiceEvent {
  final DateTime day;

  BookingServiceStared(this.day);

  @override
  List<Object> get props => [day];
}
