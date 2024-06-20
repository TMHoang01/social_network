import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/utils/text_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleItem extends Equatable {
  final String? id;
  final String? bookingId;
  final String? serviceId;
  final String? serviceName;
  final String? providerId;
  final String? customerId;
  final DateTime? date;
  final TimeOfDay? time;
  final ScheduleItemStatus? status;
  final String? note;

  const ScheduleItem({
    this.id,
    this.bookingId,
    this.serviceId,
    this.serviceName,
    this.providerId,
    this.customerId,
    this.date,
    this.time,
    this.status,
    this.note,
  });

  String get displayTime {
    if (time == null) return '';
    return TextFormat.timeOfDayToJson(time!) ?? '';
  }

  String get displayDate {
    if (date == null) return '';
    return TextFormat.formatDate(date!);
  }

  // hiển thị thứ
  String get displayWeekDay {
    if (date == null) return '';
    final List<String> weekDay = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return weekDay[date!.weekday - 1];
  }

  bool isWeekend() {
    if (date == null) return false;
    return date!.weekday == 6 || date!.weekday == 7;
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      bookingId: json['bookingId'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      providerId: json['providerId'],
      customerId: json['customerId'],
      date: TextFormat.parseJson(json['date']),
      time: TextFormat.timeOfDateFromJson(json['time']),
      status: json['status'] != null
          ? ScheduleItemStatus.fromJson(json['status'])
          : null,
      note: json['note'],
    );
  }
  factory ScheduleItem.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ScheduleItem.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  factory ScheduleItem.fromScheduleBooking(
      BookingService booking, DateTime date) {
    return ScheduleItem(
      bookingId: booking.id,
      serviceId: booking.serviceId,
      serviceName: booking.serviceName,
      providerId: booking.providerId,
      customerId: booking.userId ?? booking.createdBy,
      date: date,
      time: booking.schedule?.startTime,
      status: ScheduleItemStatus.pending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bookingId != null) 'bookingId': bookingId,
      if (serviceId != null) 'serviceId': serviceId,
      if (serviceName != null) 'serviceName': serviceName,
      if (providerId != null) 'providerId': providerId,
      if (customerId != null) 'customerId': customerId,
      if (date != null) 'date': date,
      if (time != null) 'time': TextFormat.timeOfDayToJson(time),
      if (status != null) 'status': status?.toJson(),
      if (note != null) 'note': note,
    };
  }

  ScheduleItem copyWith({
    String? id,
    String? bookingId,
    String? serviceId,
    String? serviceName,
    String? providerId,
    String? customerId,
    DateTime? date,
    TimeOfDay? time,
    ScheduleItemStatus? status,
    String? note,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      providerId: providerId ?? this.providerId,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [];
}
