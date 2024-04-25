import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_form_child_care.dart';
import 'package:social_network/presentation/screens/not_found/not_found_screen.dart';

class BookingFormFillScreen extends StatelessWidget {
  const BookingFormFillScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceCreateBloc, BookingServiceCreateState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is BookingServiceSuccess) {
          // BlocProvider.of<CartBloc>(context).add(ClearCart());
          // navService.pushNamed(context, RouterClient.complete);
        } else if (state is BookingServiceFailure) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.message),
          //     backgroundColor: Colors.red,
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return switch (state) {
          BookingServiceCreateChilCaredInitial(booking: final booking) =>
            BookingFormChildCare(booking: booking.copyWith()),
          _ => const NotFoundScreen(),
        };
      },
    );
  }
}
