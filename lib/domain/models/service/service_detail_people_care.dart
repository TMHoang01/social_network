import 'package:social_network/domain/models/service/service_detail.dart';

class ServiceDetailPeopleCare extends ServiceDetail {
  final int? childNumber;
  final String? childAge;
  final String? childGender;
  final int? timeShift;

  const ServiceDetailPeopleCare({
    this.childNumber,
    this.childAge,
    this.childGender,
    this.timeShift,
  });

  @override
  List<Object?> get props => [childNumber, childAge, childGender, timeShift];

  @override
  factory ServiceDetailPeopleCare.fromJson(Map<String, dynamic> json) {
    return ServiceDetailPeopleCare(
      childNumber: json['childNumber'],
      childAge: json['childAge'],
      childGender: json['childGender'],
      timeShift: json['timeShift'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'childNumber': childNumber,
      'childAge': childAge,
      'childGender': childGender,
      'timeShift': timeShift,
    };
  }

  @override
  ServiceDetail copyWith() {
    return ServiceDetailPeopleCare(
      childNumber: childNumber,
      childAge: childAge,
      childGender: childGender,
      timeShift: timeShift,
    );
  }
}
