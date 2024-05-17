import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    logger.d('BookingDateWidget initState ${widget.isBefore}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: widget.isBefore! ? kFirstDay : kToday,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          currentDay: _selectedDay,
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
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ),
      ],
    );
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
