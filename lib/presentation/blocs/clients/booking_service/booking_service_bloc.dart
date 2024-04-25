import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';

part 'booking_service_event.dart';
part 'booking_service_state.dart';

class BookingServiceBloc
    extends Bloc<BookingServiceEvent, BookingServiceState> {
  final BookingRepository bookingRepository;
  BookingServiceBloc(this.bookingRepository) : super(BookingServiceInitial()) {
    on<BookingServiceEvent>((event, emit) {});
    on<BookingServiceStared>((event, emit) async {
      emit(BookingServiceLoading());
      try {
        final bookingService = await bookingRepository.getSchedule(
          event.date,
        );
        emit(BookingServiceSuccess(bookingService));
      } catch (e) {
        emit(BookingServiceFailure(e.toString()));
      }
    });
  }
}
