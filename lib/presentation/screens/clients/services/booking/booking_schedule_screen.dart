import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/booking_service_child_care.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_booking.dart';
import 'package:social_network/presentation/blocs/clients/booking_service_create/booking_service_create_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/screens/clients/services/booking/booking_date.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/logger.dart';

class BookingScheduleScreen extends StatefulWidget {
  const BookingScheduleScreen({super.key});

  @override
  State<BookingScheduleScreen> createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  TimeOfDay selectTime = TimeOfDay.now();
  DateTime? beginDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  bool isReapeat = false;
  int selectPackageReapeat = 1;
  List<int> dayRepeat = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch dịch vụ'),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomeContanier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textTile('Ngày làm việc  '),
                    BookingDateWidget(onDateSelected: (date) {
                      setState(() {
                        beginDate = date;
                        endDate = DateTime(
                            beginDate!.year,
                            beginDate!.month + selectPackageReapeat,
                            beginDate!.day);
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomeContanier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textTile('Giờ làm việc'),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: selectTime,
                        );
                        if (timeOfDay != null) {
                          setState(() {
                            selectTime = timeOfDay;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            ' ${selectTime.hour.toString().padLeft(2, '0')}'
                            ':${selectTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomeContanier(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textTile('Lặp lại hàng tuần'),
                    Switch(
                        value: isReapeat,
                        onChanged: (value) {
                          setState(() {
                            isReapeat = value;
                          });
                        }),
                  ],
                ),
              ),
              // const SizedBox(height: 12),
              CustomeContanier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isReapeat,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: kSecondaryColor,
                          //   width: 1.0,
                          // ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [0, 1, 2, 3, 4, 5, 6].map((e) {
                            final List<String> dayWeeks = [
                              'T2',
                              'T3',
                              'T4',
                              'T5',
                              'T6',
                              'T7',
                              'CN'
                            ];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (dayRepeat.contains(e)) {
                                    dayRepeat.remove(e);
                                  } else {
                                    dayRepeat.add(e);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: dayRepeat.contains(e)
                                    ? kSecondaryColor
                                    : Colors.white,
                                child: Text(
                                  ' ${dayWeeks[e]} ',
                                  style: TextStyle(
                                    color: dayRepeat.contains(e)
                                        ? Colors.white
                                        : kSecondaryColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              CustomeContanier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isReapeat,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textTile('Chọn gói tháng'),
                          Row(
                            children: [
                              _builderSelectPackage(1),
                              _builderSelectPackage(2),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _builderSelectPackage(6),
                              _builderSelectPackage(12),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 1000.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          final schedule = ScheduleBooking(
            startDate: beginDate,
            endDate: endDate,
            isReapeat: isReapeat,
            repeatType: BookingRepeatType.weekly,
            dayRepeat: dayRepeat,
            startTime: selectTime,
          );

          schedule.setScheduleDates();
          final state = context.read<BookingServiceCreateBloc>().state;
          if (state is BookingServiceCreateChilCaredInitial) {
            final BookingServiceChildCare bookingSchedule =
                state.booking.copyWith(scheduleBooking: schedule);
            logger.i(bookingSchedule.toJson());
            navService.pushNamed(context, RouterClient.servicBookingCheckout,
                args: bookingSchedule);
          }
        },
        title: 'Đặt lịch',
      ),
    );
  }

  Expanded _builderSelectPackage(int num) {
    return Expanded(
      child: SizedBox(
        child: SelectWidget(
          text: '$num tháng',
          isSelect: selectPackageReapeat == num,
          onChanged: () {
            setState(() {
              selectPackageReapeat = num;
              endDate = DateTime(beginDate!.year,
                  beginDate!.month + selectPackageReapeat, beginDate!.day);
              logger.d(' beginDate $beginDate endDate $endDate');
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

class CustomeContanier extends StatelessWidget {
  final Widget child;
  const CustomeContanier({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _boxdecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
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
