part of 'booking_service_create_bloc.dart';

sealed class BookingServiceCreateEvent extends Equatable {
  const BookingServiceCreateEvent();

  @override
  List<Object> get props => [];
}

class BookingServiceCreateStared extends BookingServiceCreateEvent {
  final ServiceModel service;

  BookingServiceCreateStared(this.service);

  @override
  List<Object> get props => [service];
}

class BookingServiceCreateUpdateAdress extends BookingServiceCreateEvent {
  final InforContactModel infor;

  BookingServiceCreateUpdateAdress(this.infor);

  @override
  List<Object> get props => [infor];
}

class BookingServiceCreateUpdatePriceItem extends BookingServiceCreateEvent {
  final PriceListItem priceItem;

  BookingServiceCreateUpdatePriceItem(this.priceItem);

  @override
  List<Object> get props => [priceItem];
}

class BookingServiceCreateUpdateNote extends BookingServiceCreateEvent {
  final String note;

  BookingServiceCreateUpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class BookingServiceCreateSubmit extends BookingServiceCreateEvent {
  final BookingService booking;

  BookingServiceCreateSubmit(this.booking);

  @override
  List<Object> get props => [booking];
}

class BookingServiceCreateChangeRepeatType extends BookingServiceCreateEvent {
  final BookingRepeatType? repeatType;

  BookingServiceCreateChangeRepeatType(this.repeatType);

  @override
  List<Object> get props => [];
}

class BookingServiceCreateChangeSchedule extends BookingServiceCreateEvent {
  final ScheduleBooking schedule;

  BookingServiceCreateChangeSchedule(this.schedule);

  @override
  List<Object> get props => [schedule];
}
