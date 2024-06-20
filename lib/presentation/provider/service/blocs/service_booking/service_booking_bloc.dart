import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'service_booking_event.dart';
part 'service_booking_state.dart';

class ServiceBookingBloc
    extends Bloc<ServiceBookingEvent, ServiceBookingState> {
  final BookingRepository repository;
  ServiceBookingBloc(this.repository) : super(const ServiceBookingState()) {
    on<ServiceBookingEvent>((event, emit) {});
    on<ServiceBookingStarted>(_onServiceBookingStarted,
        transformer: droppable());
    on<ServiceBookingStartedByUser>(_onServiceBookingStartedByUser,
        transformer: droppable());
    on<ServiceBookingUpdateStatus>(_onServiceBookingUpdateStatus,
        transformer: droppable());
    on<ServiceBookingAcceptStatus>(_onServiceBookingAcceptStatus,
        transformer: droppable());
    on<ServiceBookingDetailStarted>(_onServiceBookingDetailStarted,
        transformer: droppable());
  }

  void _onServiceBookingStarted(
    ServiceBookingStarted event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(status: ServiceBookingStatus.loading));
    try {
      final list = await repository.getAll();
      emit(state.copyWith(status: ServiceBookingStatus.loaded, list: list));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceBookingStatus.error));
    }
  }

  void _onServiceBookingStartedByUser(
    ServiceBookingStartedByUser event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(status: ServiceBookingStatus.loading));
    try {
      final list = await repository.getAllByUserId(
        userId: userCurrent?.id ?? '',
      );
      emit(state.copyWith(status: ServiceBookingStatus.loaded, list: list));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceBookingStatus.error));
    }
  }

  void _onServiceBookingUpdateStatus(
    ServiceBookingUpdateStatus event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(status: ServiceBookingStatus.loading));
    try {
      await repository.updateStatus(
          status: event.status ?? BookingStatus.pending,
          id: event.bookingId ?? '');
      final list = state.list
          .map((e) => e.id == event.bookingId
              ? e.copyWith(status: event.status ?? BookingStatus.pending)
              : e)
          .toList();
      emit(state.copyWith(
        status: ServiceBookingStatus.loaded,
        list: list,
        bookingSelected: state.bookingSelected?.copyWith(status: event.status),
      ));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceBookingStatus.error));
    }
  }

  void _onServiceBookingAcceptStatus(
    ServiceBookingAcceptStatus event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(status: ServiceBookingStatus.loading));
    try {
      // find booking by id
      final booking =
          state.list.firstWhere((element) => element.id == event.bookingId);

      await repository.acceptBooking(
        booking: booking,
      );
      final list = state.list
          .map((e) => e.id == event.bookingId
              ? e.copyWith(status: BookingStatus.accepted)
              : e)
          .toList();

      emit(state.copyWith(
        status: ServiceBookingStatus.loaded,
        list: list,
        bookingSelected:
            state.bookingSelected?.copyWith(status: BookingStatus.accepted),
      ));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceBookingStatus.error));
    }
  }

  void _onServiceBookingDetailStarted(
    ServiceBookingDetailStarted event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(status: ServiceBookingStatus.loading));
    try {
      // final bookingService = await repository.getDetail(id: event.id);
      final bookingService =
          state.list.firstWhere((element) => element.id == event.bookingId);
      emit(
        state.copyWith(
            status: ServiceBookingStatus.loaded,
            bookingSelected: bookingService),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceBookingStatus.error));
    }
  }
}
