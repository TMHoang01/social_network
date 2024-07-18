import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/features/service/blocs/schedule_booking_service/schedule_booking_service_bloc.dart';
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
    BlocProvider.of<ScheduleServiceResidentBloc>(context)
        .add(ScheduleBServiceStared(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleServiceResidentBloc, BookingServiceState>(
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
                    BlocProvider.of<ScheduleServiceResidentBloc>(context)
                        .add(ScheduleBServiceStared(date ?? _selectedDate));
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
    if (state is ScheduleServiceLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is BookingServiceSuccess) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.scheduleService.length,
        itemBuilder: (context, index) {
          final schedule = state.scheduleService[index];
          return Card(
            child: ListTile(
              title: Text(schedule.serviceName ?? ''),
              subtitle: Text('${schedule.time?.hour}'
                  ':${schedule.time?.minute}'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () {
                  navService.pushNamed(context, RouterClient.bookingDetail,
                      args: schedule);
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
