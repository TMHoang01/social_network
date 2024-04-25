import 'package:social_network/domain/models/ecom/infor_contact.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_booking.dart';

class BookingServiceChildCare extends BookingService {
  final int? childNumber;
  final String? childAge;
  final String? childGender;
  final int? timeShift;

  @override
  const BookingServiceChildCare({
    String? id,
    InforContactModel? inforContact,
    ServiceType? type,
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    double? servicePrice,
    String? providerId,
    String? providerName,
    BookingStatus? status,
    ScheduleBooking? scheduleBooking,
    String? note,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? workDate,
    this.childNumber,
    this.childAge,
    this.childGender,
    this.timeShift,
  }) : super(
          id: id,
          inforContact: inforContact,
          type: type,
          serviceId: serviceId,
          serviceName: serviceName,
          serviceImage: serviceImage,
          servicePrice: servicePrice,
          providerId: providerId,
          providerName: providerName,
          status: status,
          scheduleBooking: scheduleBooking,
          note: note,
          createdAt: createdAt,
          createdBy: createdBy,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
          workDate: workDate,
        );

  @override
  factory BookingServiceChildCare.fromJson(Map<String, dynamic> json) {
    return BookingServiceChildCare(
      id: json['id'],
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
          : null,
      scheduleBooking: json['scheduleBooking'] != null
          ? ScheduleBooking.fromJson(json['scheduleBooking'])
          : null,
      note: json['note'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
      workDate: json['workDate'],
      // child care
      childNumber: json['childNumber'],
      childAge: json['childAge'],
      childGender: json['childGender'],
      timeShift: json['timeShift'],
    );
  }

  @override
  factory BookingServiceChildCare.fromBookingService(
      BookingService bookingService) {
    return BookingServiceChildCare(
      id: bookingService.id,
      inforContact: bookingService.inforContact,
      type: bookingService.type,
      serviceId: bookingService.serviceId,
      serviceName: bookingService.serviceName,
      serviceImage: bookingService.serviceImage,
      servicePrice: bookingService.servicePrice,
      providerId: bookingService.providerId,
      providerName: bookingService.providerName,
      status: bookingService.status,
      scheduleBooking: bookingService.scheduleBooking,
      note: bookingService.note,
      createdAt: bookingService.createdAt,
      createdBy: bookingService.createdBy,
      updatedAt: bookingService.updatedAt,
      updatedBy: bookingService.updatedBy,
      workDate: bookingService.workDate,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'inforContact': inforContact?.toJson(),
      'type': type?.toJson(),
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceImage': serviceImage,
      'servicePrice': servicePrice,
      'providerId': providerId,
      'providerName': providerName,
      'status': status?.toJson(),
      'scheduleBooking': scheduleBooking?.toJson(),
      'note': note,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'workDate': workDate,
      // child care
      'childNumber': childNumber,
      'childAge': childAge,
      'childGender': childGender,
      'timeShift': timeShift,
    };
  }

  @override
  BookingServiceChildCare copyWith({
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
    ScheduleBooking? scheduleBooking,
    String? note,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? workDate,
    // child care
    int? childNumber,
    String? childAge,
    String? childGender,
    int? timeShift,
  }) {
    return BookingServiceChildCare(
      id: id ?? this.id,
      inforContact: inforContact ?? this.inforContact,
      type: type ?? this.type,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImage: serviceImage ?? this.serviceImage,
      servicePrice: servicePrice ?? this.servicePrice,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      status: status ?? this.status,
      scheduleBooking: scheduleBooking ?? this.scheduleBooking,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      workDate: workDate ?? this.workDate,
      // child care
      childNumber: childNumber ?? this.childNumber,
      childAge: childAge ?? this.childAge,
      childGender: childGender ?? this.childGender,
      timeShift: timeShift ?? this.timeShift,
    );
  }
}
