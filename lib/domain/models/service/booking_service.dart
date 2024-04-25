import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/schedule_booking.dart';

import './enum_service.dart';

class BookingService extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String typeOrder = 'service';
  final InforContactModel? inforContact;
  final ServiceType? type;
  final String? serviceId;
  final String? serviceName;
  final String? serviceImage;
  final double? servicePrice;
  final String? providerId;
  final String? providerName;
  final ScheduleBooking? scheduleBooking;
  final BookingStatus? status;
  final String? note;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final DateTime? workDate;

  const BookingService({
    this.id,
    this.userId,
    this.userName,
    this.inforContact,
    this.type,
    this.serviceId,
    this.serviceName,
    this.serviceImage,
    this.servicePrice,
    this.providerId,
    this.providerName,
    this.status,
    this.scheduleBooking,
    this.note,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.workDate,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      inforContact: json['inforContact'] != null
          ? InforContactModel.fromJson(json['inforContact'])
          : null,
      type: json['type'] != null ? ServiceType.fromJson(json['type']) : null,
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceImage: json['serviceImage'],
      servicePrice: json['servicePrice'],
      providerId: json['providerId'],
      providerName: json['providerName'],
      status: json['status'] != null
          ? BookingStatus.fromJson(json['status'])
          : BookingStatus.pending,
      scheduleBooking: json['scheduleBooking'] != null
          ? ScheduleBooking.fromJson(json['scheduleBooking'])
          : null,
      note: json['note'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
      workDate: json['workDate'],
    );
  }

  factory BookingService.fromDocumentSnapshot(DocumentSnapshot doc) {
    return BookingService.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      'type': typeOrder, // 'service'
      if (inforContact != null) 'inforContact': inforContact?.toJson(),
      if (type != null) 'type': type?.toJson(),
      if (serviceId != null) 'serviceId': serviceId,
      if (serviceName != null) 'serviceName': serviceName,
      if (serviceImage != null) 'serviceImage': serviceImage,
      if (servicePrice != null) 'servicePrice': servicePrice,
      if (providerId != null) 'providerId': providerId,
      if (providerName != null) 'providerName': providerName,
      if (status != null) 'status': status?.toJson(),
      if (scheduleBooking != null) 'scheduleBooking': scheduleBooking?.toJson(),
      if (note != null) 'note': note,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (workDate != null) 'workDate': workDate,
    };
  }

  BookingService copyWith({
    String? id,
    String? userId,
    String? userName,
    InforContactModel? inforContact,
    ServiceType? type,
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    double? servicePrice,
    String? providerId,
    String? providerName,
    BookingStatus? status,
    String? note,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? workDate,
  }) {
    return BookingService(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      inforContact: inforContact ?? this.inforContact,
      type: type ?? this.type,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImage: serviceImage ?? this.serviceImage,
      servicePrice: servicePrice ?? this.servicePrice,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      workDate: workDate ?? this.workDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        inforContact,
        serviceId,
        serviceName,
        serviceImage,
        servicePrice,
        providerId,
        providerName,
        status,
      ];
}
