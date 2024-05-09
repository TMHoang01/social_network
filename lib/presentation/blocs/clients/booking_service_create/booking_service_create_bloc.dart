import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/booking_service_child_care.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/repository/service/booking_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

part 'booking_service_create_event.dart';
part 'booking_service_create_state.dart';

class BookingServiceCreateBloc
    extends Bloc<BookingServiceCreateEvent, BookingServiceCreateState> {
  final BookingRepository bookingRepository;
  BookingServiceCreateBloc(this.bookingRepository)
      : super(BookingServiceCreateInitial()) {
    on<BookingServiceCreateEvent>((event, emit) {
      emit(BookingServiceCreateInitial());
    });
    on<BookingServiceCreateSubmit>(_onBookingServiceCreateSubmit);

    on<BookingServiceCreateStared>(_onBookingServiceCreateStared);
  }

  void _onBookingServiceCreateStared(BookingServiceCreateStared event,
      Emitter<BookingServiceCreateState> emit) {
    try {
      logger.i(event.booking);
      final booking = event.booking;

      if (booking is BookingServiceChildCare) {
        emit(BookingServiceCreateInitial());
        emit(BookingServiceCreateChilCaredInitial(booking: booking));
      }
      // if (state is BookingServiceCreateChilCaredInitial) {
      //   emit(BookingServiceCreateInitial());
      //   emit(BookingServiceCreateChilCaredInitial(
      //       booking: event.booking as BookingServiceChildCare));
      // } else {
      //   emit(
      //     BookingServiceCreateChilCaredInitial(
      //       booking: BookingServiceChildCare.fromBookingService(event.booking)
      //           .copyWith(
      //         type: ServiceType.childCare,
      //       ),
      //     ),
      //   );
      // }
    } catch (e) {
      emit(BookingServiceCreateFailure(e.toString()));
    }
  }

  void _onBookingServiceCreateSubmit(BookingServiceCreateSubmit event,
      Emitter<BookingServiceCreateState> emit) async {
    emit(BookingServiceLoading());
    try {
      final booking = event.booking.copyWith(
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        createdBy: firebaseAuth.currentUser?.uid ?? '',
        userId: firebaseAuth.currentUser?.uid ?? '',
        userName: firebaseAuth.currentUser?.displayName ?? '',
      );
      final result = await bookingRepository.add(bookingService: booking);
      emit(BookingServiceCreateSuccess(result ?? BookingServiceChildCare()));
    } catch (e) {
      emit(BookingServiceCreateFailure(e.toString()));
    }
  }
}
