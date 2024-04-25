import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service/booking_service_bloc.dart';

class MýcheduleScreen extends StatefulWidget {
  const MýcheduleScreen({super.key});

  @override
  State<MýcheduleScreen> createState() => _MýcheduleScreenState();
}

class _MýcheduleScreenState extends State<MýcheduleScreen> {
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
          body: Container(
            child: SingleChildScrollView(child: Column(
              children: [
                const Text('Lịch hẹn của tôi'),
              ],
            )),
          ),
        );
      },
    );
  }
}