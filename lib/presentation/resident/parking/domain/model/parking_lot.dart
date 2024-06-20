import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ParkingLotStatus {
  available,
  occupiedUnKown,
  occupiedKnown,
  reserved;

  String toJson() => name;
  static ParkingLotStatus fromJson(String json) => values.byName(json);

  String toName() {
    switch (this) {
      case ParkingLotStatus.available:
        return 'Trống';
      case ParkingLotStatus.occupiedUnKown:
        return 'Đã có xe';
      case ParkingLotStatus.occupiedKnown:
        return 'Đã có xe';
      case ParkingLotStatus.reserved:
        return 'Đã đặt';
      default:
        return '';
    }
  }
}

class ParkingLot extends Equatable {
  final String? id;
  final double x;
  final double y;
  final double w;
  final double h;
  final String floor;
  final String zone;
  final String slot;
  final ParkingLotStatus? status;
  final String? vehicleLicensePlate;
  final String? ticketId;
  final String? ticketCode;

  const ParkingLot(
      {this.id,
      required this.x,
      required this.y,
      required this.w,
      required this.h,
      required this.floor,
      required this.zone,
      required this.slot,
      this.status,
      this.vehicleLicensePlate,
      this.ticketId,
      this.ticketCode});
  String get name => '$zone$slot';
  ParkingLot copyWith(
      {String? id,
      double? x,
      double? y,
      double? w,
      double? h,
      String? floor,
      String? zone,
      String? slot,
      ParkingLotStatus? status,
      String? vehicleLicensePlate,
      String? ticketId,
      String? ticketCode}) {
    return ParkingLot(
        id: id ?? this.id,
        x: x ?? this.x,
        y: y ?? this.y,
        w: w ?? this.w,
        h: h ?? this.h,
        floor: floor ?? this.floor,
        zone: zone ?? this.zone,
        slot: slot ?? this.slot,
        status: status ?? this.status,
        vehicleLicensePlate: vehicleLicensePlate ?? this.vehicleLicensePlate,
        ticketId: ticketId ?? this.ticketId,
        ticketCode: ticketCode ?? this.ticketCode);
  }

  get isAvailable {
    return status == ParkingLotStatus.available || ticketId == null;
  }

  Color get getBgColor {
    if (isAvailable) {
      return Colors.green;
    }
    return Colors.red;
  }

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
        x: json['x'],
        y: json['y'],
        w: json['w'],
        h: json['h'],
        floor: json['floor'],
        zone: json['zone'],
        slot: json['slot'],
        status: json['status'] != null
            ? ParkingLotStatus.fromJson(json['status'])
            : null,
        vehicleLicensePlate: json['vehicleLicensePlate'],
        ticketId: json['ticketId'],
        ticketCode: json['titketCode']);
  }

  factory ParkingLot.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ParkingLot.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'floor': floor,
      'zone': zone,
      'slot': slot,
      if (status != null) 'status': status?.toJson(),
      if (vehicleLicensePlate != null)
        'vehicleLicensePlate': vehicleLicensePlate,
      if (ticketId != null) 'ticketId': ticketId,
      if (ticketCode != null) 'titketCode': ticketCode
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        x,
        y,
        w,
        h,
        floor,
        zone,
        slot,
        status,
        vehicleLicensePlate,
        ticketId,
        ticketCode,
      ];
}
