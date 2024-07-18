part of 'service_booking_bloc.dart';

sealed class ServiceBookingProviderEvent extends Equatable {
  const ServiceBookingProviderEvent();

  @override
  List<Object> get props => [];
}

class ServiceBookingStarted extends ServiceBookingProviderEvent {}

class ServiceBookingStartedByUser extends ServiceBookingProviderEvent {}

class ServiceBookingUpdateStatus extends ServiceBookingProviderEvent {
  final String? bookingId;
  final BookingStatus? status;

  ServiceBookingUpdateStatus(this.bookingId, this.status);

  @override
  List<Object> get props => [];
}

class ServiceBookingAcceptStatus extends ServiceBookingProviderEvent {
  final String? bookingId;

  ServiceBookingAcceptStatus(this.bookingId);

  @override
  List<Object> get props => [];
}

class ServiceBookingDetailStarted extends ServiceBookingProviderEvent {
  final String? bookingId;

  ServiceBookingDetailStarted(this.bookingId);

  @override
  List<Object> get props => [];
}
