import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';
import 'package:social_network/presentation/provider/service/blocs/schedule_service/schedule_service_bloc.dart';
import 'package:social_network/sl.dart';

class ListSchedule extends StatefulWidget {
  final BookingService booking;
  const ListSchedule({super.key, required this.booking});

  @override
  State<ListSchedule> createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<ScheduleServiceBloc>()
        ..add(ScheduleServiceStarted(widget.booking.id ?? '')),
      child: BlocBuilder<ScheduleServiceBloc, ScheduleServiceState>(
        builder: (context, state) {
          final list = state.list;
          if (state.status == ScheduleServiceStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (list == null || list.isEmpty) {
            return const Center(
              child: Text('Không có lịch hẹn nào'),
            );
          }
          Map<ScheduleItemStatus?, int> mapStatus = {};
          list.forEach((element) {
            mapStatus[element.status] = (mapStatus[element.status] ?? 0) + 1;
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var item in mapStatus.entries)
                    Text('${item.key?.toName() ?? ''}: ${item.value}'),
                ],
              ),
              Container(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (context, index) {
                    if (index == list.length - 1) return const SizedBox();
                    int monthCurrentDate = list[index].date?.month ?? 0;
                    int monthNextDate = list[index + 1].date?.month ?? 0;
                    if (monthCurrentDate != monthNextDate) {
                      return Column(
                        children: [
                          const Divider(),
                          Text(
                            'Tháng $monthNextDate',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                  itemBuilder: (context, index) {
                    final item = list![index];
                    return Column(
                      children: [
                        if (index == 0)
                          Text(
                            'Tháng ${item.date?.month}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(right: 0, left: 10),
                            leading: CircleAvatar(
                              child: Text(item.displayWeekDay),
                            ),
                            trailing: _buildMenu(context, item),
                            title: Row(
                              children: [
                                Text(item.displayDate),
                                const SizedBox(width: 10),
                                Text(item.displayTime),
                              ],
                            ),
                            subtitle: Text(item.status?.toName() ?? ''),
                            onTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   RouterAdmin.scheduleServiceDetail,
                              //   arguments: item,
                              // );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildMenu(BuildContext context, ScheduleItem item) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          const PopupMenuItem(
            value: 'edit',
            child: Text('CheckIn'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Hoàn thành'),
          ),
          const PopupMenuItem(
            value: 'cancel',
            child: Text('Hủy lịch hẹn'),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'edit') {
          context.read<ScheduleServiceBloc>().add(
                ScheduleServiceUpdated(item.copyWith(
                  status: ScheduleItemStatus.checkedIn,
                )),
              );
        } else if (value == 'delete') {
          context.read<ScheduleServiceBloc>().add(
                ScheduleServiceUpdated(item.copyWith(
                  status: ScheduleItemStatus.completed,
                )),
              );
        } else {
          context.read<ScheduleServiceBloc>().add(
                ScheduleServiceUpdated(item.copyWith(
                  status: ScheduleItemStatus.canceled,
                )),
              );
        }
      },
    );
  }
}
