import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_date.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceBloc, BookingServiceState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lịch hẹn của tôi'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BookingDateWidget(
                  onDateSelected: (date) {
                    BlocProvider.of<BookingServiceBloc>(context)
                        .add(BookingServiceStared(date ?? _selectedDate));
                  },
                ),
                _builderListBooking(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _builderListBooking(BookingServiceState state) {
    if (state is BookingServiceLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is BookingServiceSuccess) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.bookingService.length,
        itemBuilder: (context, index) {
          final booking = state.bookingService[index];
          return ListTile(
            title: Text(booking.serviceName ?? ''),
            subtitle: Text('${booking.scheduleBooking?.startTime?.hour}'
                ':${booking.scheduleBooking!.startTime?.minute}'),
            trailing: Text('${booking.providerName} '),
          );
        },
      );
    } else {
      return const Center(
        child: Text('Không có lịch hẹn nào'),
      );
    }
  }
}
