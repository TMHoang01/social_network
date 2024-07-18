import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:social_network/domain/repository/service/schedule_repository.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingDateWidget extends StatefulWidget {
  final Function(DateTime? selectedDate)? onDateSelected;
  final CalendarFormat calendarFormat;
  final bool? isBefore;
  const BookingDateWidget(
      {super.key,
      this.onDateSelected,
      this.isBefore = false,
      this.calendarFormat = CalendarFormat.week});

  @override
  State<BookingDateWidget> createState() => _BookingDateWidgetState();
}

class _BookingDateWidgetState extends State<BookingDateWidget> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  late final CalendarFormat calendarFormat;
  List<DateTime> _getAvailableDates() {
    DateTime today = DateTime.now();
    List<DateTime> availableDates = [];
    for (int day = 1; day <= 31; day++) {
      DateTime date = DateTime(today.year, today.month, day);
      if (date.isAfter(today)) {
        availableDates.add(date);
      }
    }
    return availableDates;
  }

  Map<DateTime, List> _eventsList = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    loadEvent();
  }

  Future<void> loadEvent() async {
    final sheduleRepo = sl.get<ScheduleServiceRepository>();
    _eventsList =
        await sheduleRepo.schedulesInMonth(userCurrent?.id ?? '', _focusedDay);
    super.setState(() {}); // to update widget data
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);
    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Column(
      children: [
        TableCalendar(
          firstDay: widget.isBefore! ? kFirstDay : kToday,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          currentDay: _selectedDay,
          eventLoader: getEventForDay,
          calendarFormat: widget.calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                widget.onDateSelected!(selectedDay);
                _focusedDay = focusedDay;
              });
            }
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
          ),
          onPageChanged: (focusedDay) {
            logger.i(' onPageChanged $focusedDay');
            if (!isSameDay(_selectedDay, focusedDay)) {
              setState(() {
                _selectedDay = focusedDay;
                widget.onDateSelected!(focusedDay);
                _focusedDay = focusedDay;
              });
            }
            _focusedDay = focusedDay;
            loadEvent();
          },
        ),
      ],
    );
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
