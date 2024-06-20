import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/resident/features/service/screens/service_booking/booking_date.dart';
import 'package:social_network/router.dart';
import 'package:table_calendar/table_calendar.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingServiceBloc>(context)
        .add(BookingServiceStared(_selectedDate));
  }

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
                  isBefore: true,
                  calendarFormat: CalendarFormat.month,
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
          return Card(
            child: ListTile(
              title: Text(booking.serviceName ?? ''),
              subtitle: Text('${booking.schedule?.startTime?.hour}'
                  ':${booking.schedule!.startTime?.minute}'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () {
                  navService.pushNamed(context, RouterClient.bookingDetail,
                      args: booking);
                },
              ),
            ),
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
