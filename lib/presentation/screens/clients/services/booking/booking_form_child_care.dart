import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service_child_care.dart';
import 'package:social_network/presentation/blocs/clients/booking_service/booking_service_bloc.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/screens/not_found/not_found_screen.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class BookingFormChildCare extends StatefulWidget {
  final BookingServiceChildCare booking;
  const BookingFormChildCare({Key? key, required this.booking})
      : super(key: key);
  @override
  State<BookingFormChildCare> createState() => _BookingFormChildCareState();
}

class _BookingFormChildCareState extends State<BookingFormChildCare> {
  late BookingServiceChildCare booking;
  final TextEditingController _noteController =
      TextEditingController(text: 'Đặt cho bé 1 tuổi');
  // late InforContactModel inforContact;
  @override
  void initState() {
    booking = widget.booking;
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void handleBooking() {
    if (_noteController.text.isEmpty) {
      showSnackBar(context, 'Nhập ghi chú', Colors.red);
      return;
    }
    logger.d(booking.toJson());
    final bookingService = booking.copyWith(
      note: _noteController.text,
      // workDate: _workDate,
    );
    context
        .read<BookingServiceCreateBloc>()
        .add(BookingServiceCreateStared(bookingService));
    navService.pushNamed(context, RouterClient.servicBookingFormSchedule);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingServiceCreateBloc, BookingServiceCreateState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is BookingServiceSuccess) {
          // BlocProvider.of<CartBloc>(context).add(ClearCart());
          // navService.pushNamed(context, RouterClient.complete);
        } else if (state is BookingServiceCreateFailure) {
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
          BookingServiceCreateChilCaredInitial() => Scaffold(
              appBar: AppBar(
                title: const Text('Trông trẻ'),
                // leading: IconButton(
                //   icon: const Icon(Icons.arrow_back),
                //   onPressed: () {
                //     // Navigator.of(context).pop();
                //   },
                // ),
              ),
              body: Container(child: _builderFormChildCare(context)),
              bottomNavigationBar: CustomButton(
                onPressed: handleBooking,
                title: 'Đặt lịch',
              ),
            ),
          _ => const NotFoundScreen(),
        };
      },
    );
  }

  Widget _builderFormChildCare(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(booking.props.toString() ?? ''),
            BlocBuilder<InforContactBloc, InforContactState>(
              builder: (context, state) {
                if (state is InforContactLoaded) {
                  final infor = state.inforContact;
                  booking = booking.copyWith(
                    inforContact: infor,
                  );
                  return InforContactCard(infor: infor);
                } else if (state is InforContactLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InforContactEmpty) {
                  return const Center(child: Text('Chưa có thông tin liên hệ'));
                }
                return const SizedBox();
              },
            ),
            Container(
              decoration: _boxdecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textTile('Số lượng trẻ'),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: SelectWidget(
                            text: '1 trẻ',
                            isSelect: booking.childNumber == 1,
                            onChanged: () {
                              setState(() {
                                booking = booking.copyWith(childNumber: 1);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: SelectWidget(
                            text: '2 trẻ',
                            isSelect: booking.childNumber == 2,
                            onChanged: () {
                              setState(() {
                                booking = booking.copyWith(childNumber: 2);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: _boxdecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textTile('Độ tuổi'),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: SelectWidget(
                            text: '12 tháng - 6 tuổi',
                            isSelect: booking.childAge == '12 tháng - 6 tuổi',
                            onChanged: () {
                              setState(() {
                                booking = booking.copyWith(
                                    childAge: '12 tháng - 6 tuổi');
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: SelectWidget(
                            text: '7 tuổi - 11 tuổi',
                            isSelect: booking.childAge == '7 tuổi - 11 tuổi',
                            onChanged: () {
                              setState(() {
                                booking = booking.copyWith(
                                    childAge: '7 tuổi - 11 tuổi');
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: _boxdecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textTile('Thời gian làm việc'),
                  Row(
                    children: [
                      _buildTimeShift(2),
                      _buildTimeShift(4),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTimeShift(6),
                      _buildTimeShift(8),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: _boxdecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text(
                      'Ghi chú',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Nhập ghi chú',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildTimeShift(int? num) {
    return Expanded(
      child: SizedBox(
        child: SelectWidget(
          text: '$num giờ',
          isSelect: booking.timeShift == num,
          onChanged: () {
            setState(() {
              booking = booking.copyWith(timeShift: num);
            });
          },
        ),
      ),
    );
  }

  Widget _textTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration _boxdecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kGrayLight.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0.0, 8),
        )
      ],
    );
  }
}
