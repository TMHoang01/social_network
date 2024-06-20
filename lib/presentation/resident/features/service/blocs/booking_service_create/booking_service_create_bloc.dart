import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/booking_service_child_care.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/domain/models/service/schedule_booking.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'booking_service_create_event.dart';
part 'booking_service_create_state.dart';

class BookingServiceCreateBloc
    extends Bloc<BookingServiceCreateEvent, BookingServiceCreateState> {
  final BookingRepository bookingRepository;
  BookingServiceCreateBloc(this.bookingRepository)
      : super(const BookingServiceCreateState()) {
    on<BookingServiceCreateEvent>((event, emit) {});
    on<BookingServiceCreateStared>(_onBookingServiceCreateStared);
    on<BookingServiceCreateUpdateAdress>(_onBookingServiceCreateUpdateAdress);
    on<BookingServiceCreateUpdateNote>(_onBookingServiceCreateUpdateNote);
    on<BookingServiceCreateUpdatePriceItem>(
        _onBookingServiceCreateUpdatePriceItem);

    on<BookingServiceCreateChangeRepeatType>(
        _onBookingServiceCreateChangeRepeatType);
    on<BookingServiceCreateChangeSchedule>(
        _onBookingServiceCreateChangeSchedule);

    on<BookingServiceCreateSubmit>(_onBookingServiceCreateSubmit,
        transformer: droppable());
  }

  void _onBookingServiceCreateStared(BookingServiceCreateStared event,
      Emitter<BookingServiceCreateState> emit) {
    try {
      logger.i(event.service);
      final service = event.service;
      final booking = BookingServiceChildCare(
        serviceId: service.id,
        serviceName: service.title,
        providerId: service.providerId,
        providerName: service.providerName,
        serviceType: service.type,
        servicePriceType: service.priceType,
        servicePriceBase: service.priceBase,
      );
      emit(state.copyWith(
        status: BookingServiceCreateStatus.initial,
        service: service,
        booking: booking,
        schedule: ScheduleBooking(),
      ));
      logger.i(state);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onBookingServiceCreateUpdateAdress(
      BookingServiceCreateUpdateAdress event,
      Emitter<BookingServiceCreateState> emit) {
    emit(state.copyWith(
        booking: state.booking?.copyWith(inforContact: event.infor)));
  }

  void _onBookingServiceCreateUpdatePriceItem(
      BookingServiceCreateUpdatePriceItem event,
      Emitter<BookingServiceCreateState> emit) {
    emit(state.copyWith(
        booking: state.booking?.copyWith(servicePriceItem: event.priceItem)));
  }

  void _onBookingServiceCreateUpdateNote(BookingServiceCreateUpdateNote event,
      Emitter<BookingServiceCreateState> emit) {
    emit(state.copyWith(booking: state.booking?.copyWith(note: event.note)));
  }

  void _onBookingServiceCreateChangeRepeatType(
      BookingServiceCreateChangeRepeatType event,
      Emitter<BookingServiceCreateState> emit) {
    emit(
      state.copyWith(
        schedule: state.schedule?.copyWith(repeatType: event.repeatType),
      ),
    );
  }

  void _onBookingServiceCreateChangeSchedule(
      BookingServiceCreateChangeSchedule event,
      Emitter<BookingServiceCreateState> emit) {
    emit(
      state.copyWith(
          schedule: event.schedule,
          booking: state.booking?.copyWith(schedule: event.schedule)),
    );
  }

  void _onBookingServiceCreateSubmit(BookingServiceCreateSubmit event,
      Emitter<BookingServiceCreateState> emit) async {
    emit(state.copyWith(status: BookingServiceCreateStatus.loading));
    try {
      final booking = state.booking?.copyWith(
            status: BookingStatus.pending,
            createdAt: DateTime.now(),
            createdBy: userCurrent?.id ?? '',
            userId: userCurrent?.id ?? '',
            userName: userCurrent?.username ?? '',
            schedule: state.schedule,
          ) ??
          const BookingService();
      final result = await bookingRepository.add(bookingService: booking);
      emit(state.copyWith(
        status: BookingServiceCreateStatus.success,
        booking: result,
      ));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(error: e.toString()));
    }
  }
}
